package pkg

import (
	"github.com/gorilla/mux"
	"io/ioutil"
	"log"
	"net/http"
)

var serviceMap = map[string]string{
	"body":      "goldieslocks-body:9007",
}

func ProviderHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	callGoldieService(w, vars["service"], vars["img"])
}

func callGoldieService(w http.ResponseWriter, part, image string) {
	if _, ok := serviceMap[part]; !ok {
		http.Error(w, "invalid part", http.StatusNotFound)
		return
	}

	resp, err := http.Get("http://" + serviceMap[part] + "/images/" + image)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "image/svg+xml")
	w.WriteHeader(resp.StatusCode)
	_, err = w.Write(body)
	if err != nil {
		log.Printf("Write failed: %v", err)
	}
}
