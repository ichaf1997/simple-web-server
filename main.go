package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
)

func handler(w http.ResponseWriter, r *http.Request) {
	data := make(map[string]interface{})
	for k, v := range r.Header {
		data[k] = strings.Join(v, ",")

	}
	b, _ := json.MarshalIndent(data, "", "    ")

	fmt.Printf("[%v] Accept requests with Header \n%s\n", time.Now().Format("2006-01-02 15:04:05"), string(b))
	fmt.Fprintf(w, string(b))
}

func main() {

	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)

}
