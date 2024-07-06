package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
)

const (
	IMAGES_PATH = "images"
)

type CardImageData struct {
	Mapping map[string]string
}

func main() {
	if len(os.Args) != 2 {
		panic(errors.New("please provide a image_data.json file as an argument"))
	}
	path := os.Args[1]
	data := loadImageData(path)
	os.Mkdir(IMAGES_PATH, 0777)
	for cardName, url := range data.Mapping {
		download(cardName, url)
	}
}

func exists(name string) (bool, error) {
	_, err := os.Stat(name)
	if err == nil {
		return true, nil
	}
	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}
	return false, err
}

func download(cardName string, url string) {
	path := filepath.Join(IMAGES_PATH, cardName+".jpg")
	if exists, _ := exists(path); exists {
		return
	}
	out, err := os.Create(path)
	checkErr(err)
	defer out.Close()

	resp, err := http.Get(url)
	checkErr(err)
	defer resp.Body.Close()

	_, err = io.Copy(out, resp.Body)
	checkErr(err)
	fmt.Printf("downloaded %s\n", cardName)
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func loadImageData(path string) *CardImageData {
	file, err := os.Open(path)
	checkErr(err)

	defer file.Close()

	bytes, err := io.ReadAll(file)
	checkErr(err)

	var data []struct {
		Name string `json:"name"`
		Url  string `json:"url"`
	}

	err = json.Unmarshal(bytes, &data)
	checkErr(err)

	result := new(CardImageData)
	result.Mapping = make(map[string]string)
	for _, card := range data {
		name := card.Name[:len(card.Name)-len(filepath.Ext(card.Name))]
		result.Mapping[name] = card.Url
	}

	return result
}
