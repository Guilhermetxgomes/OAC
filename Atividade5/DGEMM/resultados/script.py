import os
import re
import matplotlib.pyplot as plt
import numpy as np

# Diretório onde estão os arquivos txt
directory = "./"

# Regex para extrair os dados dos arquivos
time_pattern = r"Tempo de execução para matriz (\d+x\d+): ([\d.]+) segundos"
gflops_pattern = r"GFLOPS para matriz (\d+x\d+): ([\d.#INF]+) gflops"

# Dicionários para armazenar os resultados por programa
program_results = {}

# Função para adicionar valores ao dicionário
def add_to_dict(dictionary, program, matrix_size, value):
    if program not in dictionary:
        dictionary[program] = {}
    if matrix_size not in dictionary[program]:
        dictionary[program][matrix_size] = []
    dictionary[program][matrix_size].append(value)

# Ler arquivos na pasta
txt_files = [f for f in os.listdir(directory) if f.endswith(".txt")]

for file in txt_files:
    program_name = file.split("_")[0]  # Extrair nome do programa do arquivo
    with open(os.path.join(directory, file), "r") as f:
        content = f.read()

        # Encontrar tempos e GFLOPS
        for match in re.findall(time_pattern, content):
            matrix_size, time = match
            add_to_dict(program_results, program_name, matrix_size, float(time))

        for match in re.findall(gflops_pattern, content):
            matrix_size, gflops_value = match
            if gflops_value == "1.#INF00":
                gflops_value = float("inf")
            else:
                gflops_value = float(gflops_value)
            add_to_dict(program_results, program_name, matrix_size, gflops_value)

# Fazer a média dos valores por programa e por tamanho de matriz
avg_results = {}
for program, matrices in program_results.items():
    avg_results[program] = {
        size: np.mean(values) for size, values in matrices.items()
    }

# Ordenar os tamanhos de matriz
all_sizes = sorted({size for matrices in avg_results.values() for size in matrices}, key=lambda x: int(x.split("x")[0]))

# Preparar os dados para o gráfico
x = np.arange(len(all_sizes))  # Posições das barras
bar_width = 0.15

plt.figure(figsize=(12, 8))

# Usando a forma antiga para acessar o colormap
colors = plt.cm.tab10  # Usando diretamente tab10 sem a depreciação

for i, (program, matrices) in enumerate(avg_results.items()):
    avg_gflops = [matrices.get(size, 0) for size in all_sizes]
    plt.bar(x + i * bar_width, avg_gflops, bar_width, label=program, color=colors(i))

# Configurar o gráfico
plt.title("Desempenho de GFLOPS por programa e tamanho de matriz")
plt.xlabel("Tamanho da matriz")
plt.ylabel("GFLOPS")
plt.xticks(x + bar_width * (len(avg_results) / 2), all_sizes)

# Evitar erro de max() em lista vazia
max_value = max(
    (max(matrices.values(), default=0) for matrices in avg_results.values()), 
    default=0
)
plt.ylim(0, max_value * 1.2)

plt.legend()

# Salvar e exibir o gráfico
plt.tight_layout()
plt.savefig("grafico_gflops_multiplos_programas.png")
plt.show()
