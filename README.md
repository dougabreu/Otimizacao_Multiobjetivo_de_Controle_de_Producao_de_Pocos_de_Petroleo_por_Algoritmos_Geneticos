# Otimização Multiobjetivo de Controle de Produção de Poços de Petróleo por Algoritmos Genéticos

  <h3> Aluno: Douglas de Souza Abreu  
  <h3> Matrícula: 161.898.019
  <br>
 
  Este trabalho visa a construção de um sistema de apoio a decisão para otimização multiobjetivo, que utiliza Algoritmos Genéticos para definir o controle de produção de poços de petróleo de maneira otimizada buscando maximizar tanto o valor presente líquido do projeto quanto maximizar o fator de recuperação do reservatório.

  O desenvolvimento desse trabalho foi feito em MatLab integrando a modelagem do Algoritmo Genético como otimizador e do simulador de reservatórios IMEX como avaliador das soluções. Para controle de produção de poços, foi utilizado o controle por válvulas de fluxo de poços inteligentes fazendo com que para cada poço tenhamos múltiplas possibilidades de configuração de controle de válvulas. Neste trabalho, buscamos encontrar a configuração ótima de controle de fluxo que maximize tanto o fator de recuperação do reservatório quanto o valor presente líquido do projeto, para tal utilizamos o conceito de otimização multiobjetivo.

  Utilizamos o toolbox do MatLab chamado Global Optimization, Multiobjective Optimization para implementação do Algoritmo Genético.  O sistema recebe como dados de entrada informações referentes ao reservatório de petróleo (modelo numérico que descreve o reservatório, alocação dos poços, característica das válvulas inteligentes), onde o otimizador busca o controle otimizado das válvulas. Para avaliar cada conjunto de variáveis o sistema se integra ao simulador de reservatórios IMEX que por sua vez retorna as curvas de produção de óleo, gás e água de cada poço. Esses dados são então utilizados para calcular tanto o valor presente líquido (VPL) do projeto quanto o fator de recuperação (FR) do reservatório.  Tais informações retornam para o Algoritmo Genético através da função GAmultiobject e assim se segue o ciclo evolutivo desse algoritmo de otimização. Como saída temos as melhores configurações das válvulas inteligentes para um melhor aproveitamento do reservatório maximizando simultaneamente o VPL e o FR, pelo conceito de multiobjetivo pareto.
