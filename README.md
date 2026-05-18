# Exercícios 21.1 e 21.2 – Mini-HYPER (Bratko)

Resolução dos exercícios 21.1 e 21.2 do Capítulo 21 do livro:

**BRATKO, Ivan. Prolog Programming for Artificial Intelligence. 4th Edition.**

Os exercícios utilizam o sistema Mini-HYPER para induzir regras lógicas a partir de exemplos positivos e negativos.

---

## Estrutura do Repositório

```text
bratko-ex21-mini-hyper/
├── README.md
├── ex21_1_has_daughter.pl
└── ex21_2_predecessor.pl
```

---

## Exercício 21.1 – `has_daughter`

O sistema induz a seguinte regra:

```prolog
has_daughter(X) :-
    parent(X,Y),
    female(Y).
```

Significado: uma pessoa possui filha se ela é pai/mãe de alguém do sexo feminino.

### Resultados Esperados

| Consulta | Resultado Esperado |
|--------|----------------|
| `has_daughter(tom)` | `yes` |
| `has_daughter(bob)` | `yes` |
| `has_daughter(pam)` | `no` |
| `has_daughter(pat)` | `no` |
| `has_daughter(jim)` | `no` |

---

## Exercício 21.2 – `predecessor`

O sistema induz a seguinte definição recursiva:

```prolog
predecessor(A,B) :-
    parent(A,B).

predecessor(A,B) :-
    parent(A,C),
    predecessor(C,B).
```

Significado: uma pessoa é predecessora (ancestral) de outra se for pai/mãe direto ou se for pai/mãe de alguém que também seja ancestral.

### Resultados Esperados

| Consulta | Resultado Esperado |
|--------|----------------|
| `predecessor(pam,bob)` | `yes` |
| `predecessor(pam,jim)` | `yes` |
| `predecessor(tom,ann)` | `yes` |
| `predecessor(tom,jim)` | `yes` |
| `predecessor(liz,bob)` | `no` |
| `predecessor(pam,liz)` | `no` |

---

## Como Executar no SWISH

1. Abra o SWISH.
2. Copie e cole o conteúdo do arquivo desejado:
   - `ex21_1_has_daughter.pl`
   - `ex21_2_predecessor.pl`
3. Execute a consulta:

```prolog
run.
```

4. Compare a hipótese gerada e os resultados dos testes com os resultados esperados descritos acima.

---

## Como Executar no SWI-Prolog

No terminal, execute:

```bash
swipl -q -s ex21_1_has_daughter.pl -g run -t halt
```

ou

```bash
swipl -q -s ex21_2_predecessor.pl -g run -t halt
```

---

## Observações

- Os nomes das variáveis geradas automaticamente pelo Prolog podem ser diferentes.
- Isso não altera o significado lógico das regras.
- O código foi adaptado para ser compatível com o SWISH.
- Os exercícios foram testados e produzem as hipóteses esperadas.
