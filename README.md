# Assistente Pessoal Remoto — Claude + Telegram

Instala um assistente pessoal inteligente no seu Mac, controlado pelo Telegram.

## O que você ganha

- **Assistente sempre ativo** — responde mensagens no Telegram mesmo com o Mac fechado (em segundo plano)
- **Memória persistente** — lembra de você e aprende ao longo do tempo
- **Voz** — responde em áudio com voz brasileira natural (Piper TTS, voz Faber)
- **Transcrição automática** — entende mensagens de voz que você envia
- **Proativo** — verifica tarefas pendentes a cada 30 minutos automaticamente

## Requisitos

- Mac com macOS 13 ou superior (Apple Silicon ou Intel)
- Conta no Telegram
- Conta na Anthropic (para a chave de API do Claude)
- Claude Code instalado (`npm install -g @anthropic-ai/claude-code`)

## Como instalar

Abra o Terminal e cole este comando:

```bash
curl -fsSL https://raw.githubusercontent.com/Hackerdomarketing/assistente-pessoal-claude/main/INSTALAR.md | claude --dangerously-skip-permissions
```

O Claude vai abrir e guiar você por cada passo, perguntando um item de cada vez.

## Créditos

Inspirado em [OpenClaw](https://github.com/punkpeye/openclaw) e [Vellum Assistant](https://github.com/disler/vellum-agent).
