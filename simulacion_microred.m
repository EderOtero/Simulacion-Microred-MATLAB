% =========================================================================
% Paso 2: Simulación y Modelado en MATLAB (Solar, Aerogeneradores y Demanda)
% =========================================================================

clc; clear; close all;

% Definición de las 24 horas del día (Vector fila de 24 elementos)
horas = 1:24;

%% a. Generación Solar
P_max_solar = 25; % Potencia máxima nominal en kW[cite: 1]
P_solar = zeros(1, 24); % Inicialización[cite: 1]

for h = 1:24
    if h >= 6 && h <= 18
        % Curva parabólica centrada en la hora 12 con pico en 25 kW[cite: 1]
        P_solar(h) = P_max_solar * (1 - ((h - 12) / 6)^2);
    else
        P_solar(h) = 0; % Noche (horas 1 a 5 y 19 a 24)[cite: 1]
    end
end

%% b. Generación Eólica (Aerogeneradores)
P_max_eolica = 15; % Potencia máxima nominal en kW[cite: 2]
rng(42); % Semilla fija para reproducibilidad de la fluctuación
% Generación aleatoria fluctuante entre 3 kW y 15 kW[cite: 2]
P_eolica = 3 + (P_max_eolica - 3) * rand(1, 24);

%% c. Generación Híbrida Total
P_total = P_solar + P_eolica; % Suma vectorial[cite: 2]

%% d. Demanda de la Comunidad
P_demanda = zeros(1, 24); % Inicialización[cite: 2]

for h = 1:24
    if (h >= 1 && h <= 5) || (h >= 22 && h <= 24)
        % Consumo Mínimo Nocturno (2 kW a 4 kW)[cite: 2]
        P_demanda(h) = 2 + (4 - 2) * rand(); 
    elseif (h >= 6 && h <= 17)
        % Consumo Diurno (6 kW a 10 kW)[cite: 2]
        P_demanda(h) = 6 + (10 - 6) * rand(); 
    elseif (h >= 18 && h <= 21)
        % Pico Máximo de Demanda (alcanza hasta 15 kW en la hora 19-20)[cite: 2]
        if h == 19 || h == 20
            P_demanda(h) = 15; % Potencia máxima de diseño[cite: 2]
        else
            P_demanda(h) = 12 + (15 - 12) * rand();
        end
    end
end

%% e. Visualización Gráfica
figure('Name', 'Simulación de Micro-red', 'NumberTitle', 'off');

% Graficar Generación Total y Demanda[cite: 3]
plot(horas, P_total, '-o', 'LineWidth', 2, 'Color', [0, 0.5, 0], 'DisplayName', 'Generación Total (Híbrida)');
hold on;
plot(horas, P_demanda, '-s', 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980], 'DisplayName', 'Demanda de la Comunidad');

% Configuración del gráfico[cite: 3]
title('Comportamiento Energético Diario de la Micro-red');
xlabel('Tiempo en horas');
ylabel('Potencia en Kilovatios');
xlim([1 24]);
xticks(1:24);
grid on;
legend('Location', 'northeast');

hold off;