// Package main
package main

import (
	"fmt"
	"github.com/nats-io/stan.go"
	"log"
	"sync"
	"time"
)

type myStanConn interface {
	Publish(subj, msg string) error
}

type syncStanConn struct{
	stan.Conn
}

func (c *syncStanConn) Publish(subj, msg string) error {
	ch := make(chan bool)
	var glock sync.Mutex
	var guid string
	acb := func(lguid string, err error) {
		glock.Lock()
		log.Printf("Received ACK for guid %s\n", lguid)
		defer glock.Unlock()
		if err != nil {
			log.Fatalf("Error in server ack for guid %s: %v\n", lguid, err)
		}
		if lguid != guid {
			log.Fatalf("Expected a matching guid in ack callback, got %s vs %s\n", lguid, guid)
		}
		ch <- true
	}
	msgBuf := []byte(msg)
	glock.Lock()
	guid, err := c.Conn.PublishAsync(subj, msgBuf, acb)
	if err != nil {
		return fmt.Errorf("Error during async publish: %v\n", err)
	}
	glock.Unlock()
	if guid == "" {
		return fmt.Errorf("Expected non-empty guid to be returned.")
	}
	log.Printf("Published [%s] : '%s' [guid: %s]\n", subj, msg, guid)

	select {
	case <-ch:
		break
	case <-time.After(5 * time.Second):
		return fmt.Errorf("timeout")
	}
	return nil
}

type asyncStanConn struct{
	stan.Conn
}

func (c *asyncStanConn) Publish(subj, msg string) error {
	msgBuf := []byte(msg)
	err := c.Conn.Publish(subj, msgBuf)
	if err != nil {
		return fmt.Errorf("Error during publish: %v\n", err)
	}
	log.Printf("Published [%s] : '%s'\n", subj, msg)
	return nil
}
