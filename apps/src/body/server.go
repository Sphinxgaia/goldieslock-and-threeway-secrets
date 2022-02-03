package main

import (
	"context"
	"fmt"
	"github.com/sphinxgaia/goldieslock-and-threeway-secrets/app/src/goldie-body/pkg"	
	vault "github.com/hashicorp/vault/api"
	auth "github.com/hashicorp/vault/api/auth/kubernetes"
	"os"
	"strconv"
	"time"
    "io/ioutil"

	"github.com/gorilla/mux"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"log"
	"net/http"
)

// create a new counter vector
var getCallCounter = prometheus.NewCounterVec(
	prometheus.CounterOpts{
		Name: "http_requests_total", // metric name
		Help: "Number of get requests.",
	},
	[]string{"status"}, // labels
)

var buckets = []float64{.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10}

var responseTimeHistogram = prometheus.NewHistogramVec(prometheus.HistogramOpts{
	Name:    "http_server_request_duration_seconds",
	Help:    "Histogram of response time for handler in seconds",
	Buckets: buckets,
}, []string{"route", "method", "status_code"})

type statusRecorder struct {
	http.ResponseWriter
	statusCode int
}

func (rec *statusRecorder) WriteHeader(statusCode int) {
	rec.statusCode = statusCode
	rec.ResponseWriter.WriteHeader(statusCode)
}

func getRoutePattern(r *http.Request) string {
	reqContext := mux.CurrentRoute(r)
	if pattern, _ := reqContext.GetPathTemplate(); pattern != "" {
		return pattern
	}

	fmt.Println(reqContext.GetPathRegexp())

	return "undefined"
}

func prometheusMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		rec := statusRecorder{w, 200}

		next.ServeHTTP(&rec, r)

		duration := time.Since(start)
		statusCode := strconv.Itoa(rec.statusCode)
		route := getRoutePattern(r)
		fmt.Println(duration.Seconds())
		responseTimeHistogram.WithLabelValues(route, r.Method, statusCode).Observe(duration.Seconds())
	})
}

func init() {
	err := prometheus.Register(getCallCounter)
	if err != nil {
		log.Fatal(err, "couldn't register CallCounter")
	}
	err = prometheus.Register(responseTimeHistogram)
	if err != nil {
		log.Fatal(err, "couldn't register responseTimeHistogram")
	}
}

// Fetches a key-value secret (kv-v2) after authenticating to Vault with a Kubernetes service account.
func getSecretWithKubernetesAuth(service string, jwt string, secret_path string, secret_key string) (string, error) {
	config := vault.DefaultConfig() // modify for more granular configuration

	client, err := vault.NewClient(config)
	if err != nil {
		return "", fmt.Errorf("unable to initialize Vault client: %w", err)
	}

	k8sAuth, err := auth.NewKubernetesAuth(
		service,
		auth.WithServiceAccountTokenPath(jwt),
		auth.WithMountPath("bigbear"),
	)
	if err != nil {
		return "", fmt.Errorf("unable to initialize Kubernetes auth method: %w", err)
	}

	authInfo, err := client.Auth().Login(context.TODO(), k8sAuth)
	if err != nil {
		return "", fmt.Errorf("unable to log in with Kubernetes auth: %w", err)
	}
	if authInfo == nil {
		return "", fmt.Errorf("no auth info was returned after login")
	}

	// get secret from Vault
	secret, err := client.Logical().Read(secret_path)
	if err != nil {
		return "", fmt.Errorf("unable to read secret: %w", err)
	}
	
	data, ok := secret.Data["data"].(map[string]interface{})
	if !ok {
		return "", fmt.Errorf("data type assertion failed: %T %#v", secret.Data["data"], secret.Data["data"])
	}

	// data map can contain more than one key-value pair,
	// in this case we're just grabbing one of them
	key := secret_key
	value, ok := data[key].(string)
	if !ok {
		return "", fmt.Errorf("value type assertion failed: %T %#v", data[key], data[key])
	}

	return value, nil
}

func main() {
	var serviceVersion string

	// expecting version as first parameter
	fileB, errF := ioutil.ReadFile("/secret/version")
 	if errF != nil {
		// if JWT_PATH kubernetes API Auth 
		jwt_path, ok := os.LookupEnv("JWT_PATH")
		// if not present try Vault plugin 
		if ok {

			var secret_path = os.Getenv("SECRET_PATH")
			var secret_key = os.Getenv("SECRET_KEY")

			var serviceAccountName = os.Getenv("SA")

			version, errF := getSecretWithKubernetesAuth(serviceAccountName, jwt_path, secret_path, secret_key)
			if errF == nil {

				fmt.Println("Retreive secret: API")

				serviceVersion = version

				toenv, ok := os.LookupEnv("EXPORT_TO_ENV")

				// if not present try Vault plugin 
				if ok && toenv == "true" {
					os.Setenv("VERSION", version)
				}

			} else {
				fmt.Println("Retreive secret: ENV VAR")
				
				// Search ENV var VERSION
				var ver = os.Getenv("VERSION")
				// set Version
				serviceVersion = ver
			}
		} else {
			fmt.Println("Retreive secret: ENV VAR")

			// Search ENV var VERSION
			var ver = os.Getenv("VERSION")
			// set Version
			serviceVersion = ver
		}
 	} else {
		fmt.Println("Retreive secret: File")
		serviceVersion = string(fileB)
	}

	router := mux.NewRouter()
	router.Use(prometheusMiddleware)

	staticDir := "/static/images/"
	versionedHandler := pkg.NewVersionedHandler(serviceVersion, staticDir)

	// Serving image
	router.Path("/images/{body}").HandlerFunc(versionedHandler.Handler)

	router.Path("/metrics").Handler(promhttp.Handler())

	port, ok := os.LookupEnv("PORT")

	if !ok {
		fmt.Println("Serving requests on port 9000")
		err := http.ListenAndServe(":9000", router)
		log.Fatal(err)
	} else {
		fmt.Errorf("Serving requests on port %s", port)
		err := http.ListenAndServe(":" + port, router)
		log.Fatal(err)
	}
}
