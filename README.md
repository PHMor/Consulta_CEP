# Consulta CEP

Aplicativo Flutter para consultar endereços brasileiros pelo CEP.

## API utilizada

ViaCEP: https://viacep.com.br/

Requisição GET: https://viacep.com.br/ws/01001000/json/

A API é pública e não exige token. http, async/await e jsonDecode para consultar e apresentar rua, bairro, cidade, estado, complemento e DDD.

## Executar

```sh
flutter pub get
flutter run
```

## Verificar

```sh
flutter analyze
flutter test
```