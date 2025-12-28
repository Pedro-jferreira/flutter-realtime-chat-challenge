# Fluggo - Team Chat App

**Fluggo** é um aplicativo de chat em tempo real desenvolvido em Flutter, focado em comunicação eficiente para equipes.
O projeto utiliza arquitetura **MVVM**, padrão **Command** e **Firebase** como backend.

## 🚀 Funcionalidades

* **Autenticação:** Login e Registro com Firebase Auth.
* **Chat em Tempo Real:** Envio e recebimento instantâneo (Firebase Realtime Database).
* **Status de Leitura:** Visualização detalhada de quem leu e quando (Recibos de Leitura).
* **Interações Avançadas:**
    * *Clique Longo:* Copiar mensagem.
    * *Clique Curto:* Menu de opções e verificação de leitura.
    * *Clique no Nome:* Exibe o nome completo do remetente (Tooltip).
* **UX:** Scroll automático inteligente e feedback visual de carregamento.

## 🛠️ Tecnologias e Arquitetura

O projeto segue princípios de **Clean Architecture** organizados por Features na camada de UI.

* **Flutter & Dart**
* **Firebase:** Auth e Realtime Database.
* **Gerenciamento de Estado & DI:** `Provider` (Injeção via árvore de widgets) + `ChangeNotifier` + `Command`.
* **Imutabilidade:** `freezed` e `json_serializable`.
* **Tratamento de Erros:** `result_dart` (Railway Oriented Programming).
* **Navegação:** `go_router`.

## 📂 Estrutura de Pastas

O projeto está organizado separando o **Core** (lógica pura e dados) da **UI** (que é dividida por features):

```
lib/ 
├── core/ # Núcleo da aplicação 
│    ├── converters/ # Conversores JSON (ex: Datas) 
│    ├── failure/ # Tratamento de erros padronizado 
│    └── router/ # Configuração de rotas (GoRouter) 
├── models/ # Modelos de dados (Freezed) 
│    ├── auth 
│    ├── chats 
│    └── gen # Arquivos gerados (.freezed, .g) 
├── repositories/ # Regras de Negócio e Repositórios 
│    ├── auth_repository.dart 
│    └── chat_repository.dart 
├── services/ # Comunicação externa (Firebase) 
│    ├── chat_service.dart 
│    ├── firebase_auth_service.dart 
│    └── user_service.dart 
└── ui/ # Interface do Usuário 
     ├── core/ 
     │     └── theme/ # Temas e Estilos globais 
     └── feature/ # Organização por Funcionalidade 
          ├── chat/ 
          │     ├── widgets/ # Componentes exclusivos (Bubbles, Input) 
          │     ├── viewmodels/ # ChatViewModel 
          │     └── chat_screen.dart 
          ├── login/ 
          │     ├── viewmodels/ # LoginViewModel 
          │     └── login_screen.dart 
          └── register/ 
                ├── viewmodels/ # RegisterViewModel 
                ├── name_setup_screen.dart 
                └── register_screen.dart
```

## 📦 Como Baixar e Gerar o APK

Siga os passos abaixo para baixar o código, configurar e gerar o arquivo de instalação (`.apk`).

### Pré-requisitos

* Flutter SDK instalado e configurado.
* Java/JDK configurado.
* **Importante:** Você precisará adicionar seu próprio arquivo `google-services.json` (do Firebase Console) na pasta
  `android/app/` para que o app conecte ao banco de dados.

### Passo a Passo

1. **Clonar o repositório:**
   Abra o terminal e execute:
   ```bash
   git clone https://github.com/Pedro-jferreira/flutter-realtime-chat-challenge.git
   ```
   Entre na pasta do projeto:
   ```bash
   cd flutter-realtime-chat-challenge
   ```

2. **Baixar as dependências:**
   ```bash
   flutter pub get
   ```

3. **Gerar arquivos de código:**
   O projeto utiliza `freezed`, então é necessário rodar o gerador de código:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Compilar o APK:**
   Gera a versão de release otimizada para Android:
   ```bash
   flutter build apk --release
   ```

### Localizando o Arquivo Gerado

Após o término da compilação, o arquivo de instalação estará disponível em:
📂 **`build/app/outputs/flutter-apk/app-release.apk`**

Você pode copiar este arquivo e instalar em qualquer dispositivo Android.

---

**Desenvolvido por:** Pedro Ferreira

