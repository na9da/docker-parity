FROM ubuntu:16.04
WORKDIR /build
# install tools and dependencies
RUN apt update && \
        apt install -y \
        build-essential \
        g++ \
        curl \
        git \
        file \
        binutils

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# show backtraces
ENV RUST_BACKTRACE 1

# show tools
RUN rustc -vV && \
cargo -V && \
gcc -v &&\
g++ -v

# build parity
RUN git clone https://github.com/ethcore/parity && \
        cd parity && \
        git checkout stable && \
        git pull && \
        cargo build --release --verbose && \
        ls /build/parity/target/release/parity && \
        strip /build/parity/target/release/parity

RUN file /build/parity/target/release/parity

EXPOSE 8080 8545 8180
CMD ["/build/parity/target/release/parity", "--chain", "ropsten", "--tracing", "on", "--jsonrpc-interface", "0.0.0.0", "--jsonrpc-hosts", "all"]
