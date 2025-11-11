#!/usr/bin/env bash
set -e

# Start FastAPI: runs in background so streamlit can run in foreground
uvicorn app_fastapi:app --host 0.0.0.0 --port ${FASTAPI_PORT} --workers 1 &

# Give FastAPI a moment to come up
sleep 1

# Start Streamlit in foreground
export STREAMLIT_SERVER_PORT=${STREAMLIT_PORT}
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false
streamlit run app_streamlit.py --server.port ${STREAMLIT_PORT} --server.address 0.0.0.0

