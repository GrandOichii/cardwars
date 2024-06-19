package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/labstack/echo/v4"
)

const (
	image_data_path = "image_data.json"
)

type CardImageData struct {
	Mapping map[string]string
}

func main() {
	data := loadImageData()
	fmt.Printf("len(data.Mapping): %v\n", len(data.Mapping))

	e := echo.New()
	e.GET("/:name", func(c echo.Context) error {
		name := c.Param("name")
		url, exists := data.Mapping[name]
		if !exists {
			return c.String(http.StatusNotFound, fmt.Sprintf("image for card %s not found", name))
		}
		return c.Redirect(http.StatusFound, url)
	})
	e.Logger.Fatal(e.Start(":1323"))
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func loadImageData() *CardImageData {
	file, err := os.Open(image_data_path)
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

	for key, value := range result.Mapping {
		fmt.Printf("%s: %s\n", key, value)
	}

	return result
}
