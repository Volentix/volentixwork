#!/usr/bin/env bash

mkdir -p dist

GREEN='\033[0;32m'
NC='\033[0m'

# eosio.wps
echo -e "${GREEN}Compiling volentixwork...${NC}"
eosio-cpp -abigen \
  ./src/volentixwork.cpp \
  -contract volentixwork \
  -R ./ricardian \
  -o ./dist/volentixwork.wasm \
  -I ./include \
  -I ./external/eosio.token/include \
  -I ./external/eosio.system/include

# # eosio.token
# echo -e "${GREEN}Compiling eosio.token...${NC}"
# eosio-cpp -abigen \
#   external/eosio.token/src/eosio.token.cpp \
#   -contract eosio.token \
#   -o ./dist/eosio.token.wasm \
#   -I external/eosio.token/include
