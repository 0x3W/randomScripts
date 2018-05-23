FROM python:3
COPY streamTest.py /
COPY requirements.txt /
RUN pip install -r requirements.txt
CMD [ "python", "streamTest.py" ]
