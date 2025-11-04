
FROM python:3.9.23-slim

WORKDIR /app

COPY ./src/* /app/

RUN pip install -r requirements.txt

EXPOSE 6300

CMD ["python", "server.py"]
