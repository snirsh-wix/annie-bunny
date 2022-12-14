FROM rust:1.54 as build

RUN USER=root rustup default nightly
RUN USER=root cargo new --bin annie-bunny
WORKDIR /annie-bunny

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

RUN cargo b -r
RUN rm src/*.rs

COPY ./src ./src

RUN rm ./target/release/deps/annie_bunny*
RUN cargo b -r

FROM debian:buster-slim

COPY --from=build /annie-bunny/target/release/annie-bunny /usr/src/annie-bunny

EXPOSE 8000

CMD ["/usr/src/annie-bunny"]
