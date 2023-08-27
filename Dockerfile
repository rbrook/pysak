FROM python:3-slim

# update OS and install usefull tools
RUN apt update && apt upgrade
RUN apt install -y nano tmux

# add a non-root user
RUN useradd -ms /bin/bash debian
WORKDIR /home/debian
USER debian

# syntax highlighing for bash and Nano text editor
COPY bashrc_extras.sh .
RUN cat bashrc_extras.sh >> .bashrc && rm bashrc_extras.sh
COPY .nanorc .

# prapare Python's venv where 
ENV VIRTUAL_ENV=/home/debian/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -U pip

# install Python third parties (reuse .venv for Poetry)
RUN pip install poetry
ENV POETRY_VIRTUALENVS_CREATE=true
COPY --chmod=777 pyproject.toml .
RUN poetry install

CMD ["bash"]
