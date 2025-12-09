clc; clear; close all;

% Lista de estações VTEC
stations = {'SALU', 'RSPE', 'ROSA', 'PASM', 'ONRJ', 'MTGA', 'SJSP', 'APLJ'};

% --- Criar pasta 'images' dentro do diretório atual, se não existir
output_dir = fullfile(pwd, 'images');  % pwd retorna o diretório atual do MATLAB
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end


for s = 1:length(stations)
    station = stations{s};
    
    % Definir nome do arquivo
    if strcmp(station,'ONRJ')
        filename = [station '-2017-08(01-31)_5min_Concatenado.txt'];
    else
        filename = [station '-2017-08(01-31)_5min_Concatenado.txt'];
    end
    
    if ~isfile(filename)
        warning('Arquivo não encontrado: %s. Pulando esta estação.', filename);
        continue;
    end
    
    disp(['Lendo arquivo ' filename ' ...']);
    
    % Ler dados (sem cabeçalho)
    data = readmatrix(filename);
    
    % Número de colunas pares (hora + tec)
    nCols = size(data,2);
    if mod(nCols,2) ~= 0
        warning('Número de colunas ímpar. Checar arquivo %s', filename);
        continue;
    end
    
    tec_all = [];
    
    % Concatenar todas as colunas de TEC
    for k = 2:2:nCols
        tec_all = [tec_all; data(:,k)]; %#ok<AGROW>
    end
    
    % Criar vetor de tempo
    N = length(tec_all);
    start_time = datetime('01-Aug-2017 00:00','InputFormat','dd-MMM-yyyy HH:mm');
    timeVec = start_time + minutes(5*(0:N-1));
    
    % Tratar NaNs
    mask_nan = isnan(tec_all);
    tec_clean = tec_all;
    tec_clean(mask_nan) = 0;
    
    % Preparar extensão do sinal para CWT
    left2 = flipud(tec_clean);
    sig_ext = [left2; left2; tec_clean; left2; left2];
    
    fs = 1/300; % amostragem a cada 300s (5min)
    
    % Banco de filtros CWT
    fb = cwtfilterbank('SignalLength', length(sig_ext), ...
                       'SamplingFrequency', fs, ...
                       'FrequencyLimits', [1e-7 1e-4]);
    
    [cfs, freq] = cwt(sig_ext, 'FilterBank', fb);
    
    % Recortar parte central
    n = length(tec_clean);
    cfs_central = cfs(:, 2*n+1 : 3*n);
    
    % Período em dias
    period_days = (1 ./ freq) / (60*60*24);
    period_lin = flipud(period_days);
    
    % Matriz para plotagem
    W = abs(cfs_central).^2;
    W(:, mask_nan) = NaN;
    W = flipud(W);
    
    % Plotagem
    figure('Name', ['CWT - VTEC - ' station], 'NumberTitle', 'off');
    xnum = datenum(timeVec);
    
    h = pcolor(xnum, log2(period_lin), W ./ max(W(:)));
    set(h, 'EdgeColor', 'none', 'AlphaData', ~isnan(W));
    colormap jet; 
    % Barra de cor
        c = colorbar;
        c.Label.FontSize = 16;
        c.FontSize = 16;
        
        % Ajustar limites e ticks do colorbar para coerência de 0 a 1
c.Limits = [0 1];
c.Ticks = 0.1:0.1:0.9;                % ticks de 0.1 a 0.9
c.TickLabels = string(c.Ticks);

set(gca, 'Color', 'w');
            
    ax = gca;
    % Eixo X (datas)
    xticks_dates = datetime(2017,8,1):days(2):datetime(2017,8,31);
    ax.XTick = datenum(xticks_dates);
    ax.XTickLabel = datestr(xticks_dates, 'dd');
    ax.XTickLabelRotation = 90;
    ax.XLim = [datenum(datetime(2017,8,1)), datenum(datetime(2017,8,31)) + 1 - eps];
    
    % Eixo Y (períodos)
    desired_periods = [0.25 0.5 1 2 4 8 16 31];
    ax.YTick = log2(desired_periods);
    ax.YTickLabel = string(desired_periods);
    ylim(log2([0.25 31]));
    
    xlabel('Time (days)', 'FontSize', 16,'FontWeight', 'bold');
    ylabel('Period (days)', 'FontSize', 16, 'FontWeight', 'bold');
    title(['CWT - VTEC - ' station], 'FontSize', 16);
    
    grid on;
    ax.GridAlpha = 0.3;
    ax.GridColor = [0.5 0.5 0.5];
    ax.GridLineStyle = '-';
    ax.LineWidth = 1.5;
    ax.TickLength = [0.02 0.04];
    ax.FontSize = 16;
    
    % --- Salvar figura automaticamente
saveas(gcf, fullfile(output_dir, [station '.png']));
end
