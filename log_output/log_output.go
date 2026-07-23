package main

import (
	"fmt"
	"math/rand"
	"time"
)

func randomString(length int) string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

	b := make([]byte, length)

	for i := range b {
		b[i] = charset[rand.Intn(len(charset))]
	}

	return string(b)
}

func main() {
	rand.Seed(time.Now().UnixNano())

	const strLength = 12 // You can adjust the length as needed.
	randomStr := randomString(strLength)

	fmt.Printf("Application started. Generated string: %q\n", randomStr)

	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop() // Good practice: stop the ticker when main exits.

	fmt.Println("Output every 5 seconds (press Ctrl+C to stop):")

	for {
		currentTime := <-ticker.C

		timestamp := currentTime.Format("2006-01-02 15:04:05")

		fmt.Printf("[%s] %s\n", timestamp, randomStr)
	}
}
