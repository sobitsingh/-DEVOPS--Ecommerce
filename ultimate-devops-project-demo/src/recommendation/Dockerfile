FROM python:3.12-slim-bookworm as build

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .
ENTRYPOINT ["python","recommendation_server.py"]