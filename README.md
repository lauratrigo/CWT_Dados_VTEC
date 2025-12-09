# ☀️ Análise Wavelet Contínua (CWT) de Dados VTEC - Múltiplas Estações

Este repositório contém scripts MATLAB desenvolvidos para realizar a **Análise Wavelet Contínua (CWT)** de séries temporais de **VTEC (Vertical Total Electron Content)** provenientes das seguintes estações:

- **SALU**  
- **RSPE**  
- **ROSA**  
- **PASM**  
- **ONRJ**  
- **MTGA**  
- **SJSP**  
- **APLJ**

O período analisado foi de **01/08/2017 a 31/08/2017**, com passo temporal de **5 minutos**.  
O objetivo é investigar a variabilidade temporal e as periodicidades do conteúdo eletrônico total da ionosfera usando transformadas wavelet.

---

## 🛠 Tecnologias Usadas

- **MATLAB (R2019b ou superior recomendado)**
- **Wavelet Toolbox**
- **Arquivos de dados VTEC em formato .txt**

![MATLAB Badge](https://img.shields.io/badge/MATLAB-R2019b-orange?logo=Mathworks&logoColor=white)

---

## 💡 Objetivo

O projeto realiza a análise espectral de séries de VTEC para múltiplas estações, permitindo:

- 🌀 Identificação de periodicidades entre **0,25 a 31 dias**
- 🔍 Localização temporal de eventos ionosféricos relevantes
- 🌙 Observação de variações diurnas e noturnas
- 🧽 Tratamento consistente de dados ausentes (NaN)
- 📊 Geração de mapas espectrais tempo–período normalizados

---

## 📊 Funcionalidades

- 📁 Leitura automática de arquivos `.txt` de VTEC (sem cabeçalho)  
- 🕒 Construção do vetor temporal com resolução de 5 minutos  
- 🧱 Extensão do sinal para reduzir efeitos de borda na CWT  
- 🌀 Cálculo da **CWT** usando `cwtfilterbank`  
- 🎨 Visualizações com:  
  - Escala **log2(period)**  
  - Transparência automática em regiões com NaN  
  - Colormap **jet**  
  - Ticks diários no eixo do tempo  
  - Barra de cor normalizada de 0 a 1  
- 📈 Cada estação gera um gráfico Wavelet do VTEC

---

## 📂 Estrutura do Projeto
```
analise-cwt-vtec/
├── dados/
│ ├── SALU-2017-08(01-31)_5min_Concatenado.txt
│ ├── RSPE-2017-08(01-31)_5min_Concatenado.txt
│ ├── ROSA-2017-08(01-31)_5min_Concatenado.txt
│ └── ... (outros arquivos de estação)
│
├── codigo_cwt_vtec.m # Script principal de CWT para todas as estações
└── README.md # Este arquivo
```


---

## ▶️ Como Executar o Projeto

1. Clone o repositório:

```bash
git clone https://github.com/seuusuario/Analise_CWT_VTEC_2017.git
cd Analise_CWT_VTEC_2017
```

2. Abra o MATLAB.

3. Garanta que os arquivos `.txt` de VTEC estejam dentro da pasta `dados/`.

4. Execute o script:

```matlab
run codigo_cwt_vtec.m
```

---

O script irá gerar gráficos CWT para cada estação listada, com escalas de período de 0,25 a 31 dias e normalização de 0 a 1.

## 🧪 Dados Utilizados

Os arquivos `.txt` contêm séries temporais de **VTEC** com as seguintes características:

- Resolução de **5 minutos**
- Colunas: **hora + TEC**
- Período: **01/08/2017 — 31/08/2017**
- Possíveis NaNs (valores ausentes), tratados como zero para processamento

---

## 📈 Exemplos de Saída

### Estação SALU

![CWT VTEC SALU](images/SALU_VTEC.png)

### Estação RSPE

![CWT VTEC RSPE](images/RSPE_VTEC.png)

### Estação ROSA

![CWT VTEC ROSA](images/ROSA_VTEC.png)

### Estação PASM

![CWT VTEC PASM](images/PASM_VTEC.png)

### Estação ONRJ

![CWT VTEC ONRJ](images/ONRJ_VTEC.png)

### Estação MTGA

![CWT VTEC MTGA](images/MTGA_VTEC.png)

### Estação SJSP

![CWT VTEC SJSP](images/SJSP_VTEC.png)

### Estação APLJ

![CWT VTEC APLJ](images/APLJ_VTEC.png)

--- 

## 🤝 Agradecimentos

Este projeto foi desenvolvido como parte de um trabalho de pesquisa em Física Espacial no IP&D/UNIVAP, com apoio do grupo de estudos em ionosfera.

---

## 📜 Licença

Este repositório está licenciado sob a Licença MIT. Consulte o arquivo LICENSE para mais informações.
