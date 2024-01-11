FROM cdrx/pyinstaller-windows:python3

COPY requirements.txt /src
RUN pip install -r requirements.txt && rm -f requirements.txt

