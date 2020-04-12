#!/usr/bin/env bash

mkdir -p dist

GREEN='\033[0;32m'
NC='\033[0m'

# volentixwork
echo -e "${GREEN}Compiling volentixwork...${NC}"
eosio-cpp -abigen \
  ./src/volentixwork.cpp \
  -contract volentixwork \
  -R ./ricardian \
  -o ./dist/volentixwork.wasm \
  -I ./include \
  -I ./external/volentixgsys/src \
  -I ./external/eosio.token/include \
  -I ./external/eosio.system/include
