#!/bin/bash
# Quick SPX to SPY converter
# SPY ≈ SPX / 10 (ratio drifts slightly but close enough)

if [ -z "$1" ]; then
  echo "Usage: spx-to-spy.sh <SPX_PRICE>"
  echo "Example: spx-to-spy.sh 6870"
  exit 1
fi

SPX=$1
SPY=$(echo "scale=2; $SPX / 10" | bc)

echo "SPX $SPX → SPY $SPY"
