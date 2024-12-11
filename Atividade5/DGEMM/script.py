import matplotlib.pyplot as plt
import re

# Ler o arquivo
with open('Atividade5/DGEMM/resultados.txt', 'r') as file:
    lines = file.readlines()

# Extrair os tamanhos das matrizes e os GFLOPS
tamanhos = []
gflops = []

for line in lines:
    if "matriz" in line and "GFLOPS" in line:
        # Extrair o tamanho da matriz
        tamanho = re.search(r'(\d+x\d+)', line).group(1)
        # Extrair o valor de GFLOPS
        valor = re.search(r'([\d\.]+)', line.split(':')[-1])
        if valor:
            tamanhos.append(tamanho)
            gflops.append(float(valor.group(1)))

# Criar o gráfico
plt.figure(figsize=(10, 6))
plt.bar(tamanhos, gflops, color='dodgerblue', edgecolor='black')

# Configurações do gráfico
plt.title('Performance em GFLOPS para diferentes tamanhos de matriz', fontsize=14)
plt.xlabel('Tamanho da Matriz', fontsize=12)
plt.ylabel('Performance (GFLOPS)', fontsize=12)
plt.xticks(fontsize=10)
plt.yticks(fontsize=10)

# Mostrar os valores no topo das barras
for i, v in enumerate(gflops):
    plt.text(i, v + 0.05, f'{v:.2f}', ha='center', fontsize=10)

plt.tight_layout()
plt.show()