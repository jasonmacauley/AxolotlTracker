#!/bin/bash

SECRET_KEY_BASE=bundle exec rake secret
echo $SECRET_KEY_BASE
