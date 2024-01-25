import subprocess

def get_ip():
  """
  Pega o IP do computador atual.

  Retorna:
    O endereço IP do computador atual.
  """

  # Executa o comando `ifconfig`.
  output = subprocess.run(["ifconfig"], stdout=subprocess.PIPE)

  # Procura por uma linha que comece com "inet ".
  for line in output.stdout.decode("utf-8").splitlines():
    if line.startswith("inet "):
      # Separa o endereço IP da linha.
      ip = line.split(" ")[1]

      # Remove os espaços do endereço IP.
      ip = ip.strip()

      return ip

  # Se não encontrar nenhum endereço IP, retorna None.
  return None


if __name__ == "__main__":
  # Imprime o endereço IP.
  print(get_ip())
