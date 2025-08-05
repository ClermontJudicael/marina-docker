# Utilise une image Python officielle
FROM python:3.9-slim

# Installer les dépendances OCaml
RUN apt-get update && apt-get install -y \
    ocaml \
    opam \
    make \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Initialiser OPAM
RUN opam init --disable-sandboxing -y
ENV PATH="/root/.opam/bin:${PATH}"

# Copier les fichiers
COPY marina /app/marina
COPY api /app/api
COPY entrypoint.sh /app/

# Compiler Marina
WORKDIR /app/marina
RUN make

# Installer les dépendances Python
WORKDIR /app/api
RUN pip install -r requirements.txt

# Configuration finale
WORKDIR /app
RUN chmod +x entrypoint.sh
EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
