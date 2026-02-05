FROM python:3.12


WORKDIR /code
COPY requirements.txt /code/
RUN pip install --upgrade pip --progress-bar off && pip install -r requirements.txt --progress-bar off

RUN pip install gunicorn --progress-bar off

COPY . /code/
