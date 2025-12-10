clc; clear; close all;

% ============================================================
%     SELECIONAR A PASTA COM OS ARQUIVOS ORIGINAIS .TXT
% ============================================================

pasta_dados = uigetdir([], 'Selecione a pasta com os arquivos originais .txt');
if pasta_dados == 0
    error('Nenhuma pasta selecionada.');
end

fprintf("=== Pasta selecionada: %s ===\n\n", pasta_dados);

% Procurar arquivos originais (não 5min e não concatenados)
arquivos_lista = dir(fullfile(pasta_dados, '*.txt'));
arquivos = {};

for i = 1:length(arquivos_lista)
    nome = arquivos_lista(i).name;
    % ignorar arquivos processados anteriormente
    if contains(nome, '_5min') || contains(nome, 'Concatenado')
        continue;
    end
    arquivos{end+1} = erase(nome, '.txt'); % salva sem o .txt
end

if isempty(arquivos)
    error('Nenhum arquivo original .txt encontrado (somente arquivos processados existem).');
end

fprintf("Arquivos encontrados:\n");
disp(arquivos');

fprintf("\n==== INICIANDO PROCESSAMENTO ====\n\n");

% ============================================================
%          LOOP CONVERTE E CONCATENA
% ============================================================

for k = 1:length(arquivos)

    nome_base = arquivos{k};
    arquivo_entrada = fullfile(pasta_dados, [nome_base, '.txt']);
    arquivo_saida_5min = fullfile(pasta_dados, [nome_base, '_5min.txt']);

    fprintf("Convertendo arquivo para 5 min: %s\n", arquivo_entrada);

    % ============================================================
    %   PARTE 1 CONVERSÃO PARA 5 MIN
    % ============================================================

    opts = detectImportOptions(arquivo_entrada, 'Delimiter', '\t', 'NumHeaderLines', 0);
    T = readtable(arquivo_entrada, opts);

    % Remover 3 primeiras colunas
    T(:, 1:3) = [];

    num_colunas = width(T);
    num_linhas = floor(height(T) / 5);
    dados_medios = cell(num_linhas, num_colunas);

    for i = 1:num_linhas
        idx_inicio = (i-1)*5 + 1;
        idx_fim = idx_inicio + 4;

        bloco = T(idx_inicio:idx_fim, :);

        for j = 1:2:num_colunas
            horas = bloco{:, j};
            valores = bloco{:, j+1};

            if iscell(valores)
                valores_num = str2double(strrep(valores, ',', '.'));
            else
                valores_num = valores;
            end

            valores_validos = valores_num(valores_num ~= -999.0);

            if isempty(valores_validos)
                media_valor = -999.0;
            else
                media_valor = mean(valores_validos, 'omitnan');
            end

            dados_medios{i, j} = bloco{1, j};
            dados_medios{i, j+1} = strrep(sprintf('%.2f', media_valor), '.', ',');
        end
    end

    % salvar arquivo de 5 minutos
    Tfinal = cell2table(dados_medios, 'VariableNames', T.Properties.VariableNames);
    writetable(Tfinal, arquivo_saida_5min, 'Delimiter', '\t', 'WriteVariableNames', true);

    fprintf("[OK] Criado: %s\n", arquivo_saida_5min);

    % ============================================================
    %   PARTE 2 CONCATENAÇÃO / LIMPEZA
    % ============================================================

    fprintf("Concatenando arquivo: %s\n", arquivo_saida_5min);

    opts2 = detectImportOptions(arquivo_saida_5min, ...
        'Delimiter', {'\t',' ',';'}, ...
        'DecimalSeparator', ',');

    T5 = readtable(arquivo_saida_5min, opts2);

    idxHora = find(contains(T5.Properties.VariableNames, 'Hora'));
    idxTec  = find(contains(T5.Properties.VariableNames, 'Tec'));

    npairs = min(length(idxHora), length(idxTec));

    arquivo_concat = fullfile(pasta_dados, [nome_base, '_5min_Concatenado.txt']);
    fid = fopen(arquivo_concat, 'w');

    for p = 1:npairs

        h = T5{:, idxHora(p)};
        t = T5{:, idxTec(p)};

        h = str2double(string(h));
        t = str2double(string(t));

        h(h == -999.00 | h > 99.99) = NaN;
        t(t == -999.00 | t > 99.99) = NaN;

        for i = 1:length(h)

            if isnan(h(i))
                fprintf(fid, "NaN\t");
            else
                fprintf(fid, "%.2f\t", h(i));
            end

            if isnan(t(i))
                fprintf(fid, "NaN\n");
            else
                fprintf(fid, "%.2f\n", t(i));
            end

        end
    end

    fclose(fid);

    fprintf("[OK] Criado: %s\n\n", arquivo_concat);
end

fprintf("==== PROCESSO CONCLUÍDO PARA TODOS OS ARQUIVOS ====\n");
