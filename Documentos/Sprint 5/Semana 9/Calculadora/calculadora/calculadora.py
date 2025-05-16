class Calculadora:
    def adicao(self, a, b):
        return round(a + b, 2)

    def subtracao(self, a, b):
        return round(a - b, 2)

    def multiplicacao(self, a, b):
        return round(a * b, 2)

    def divisao(self, a, b):
        if b == 0:
            raise ZeroDivisionError("Não é possível dividir por zero.")
        return round(a / b, 2)

    def potenciacao(self, a, b):
        return round(a ** b, 2)

    def radiciacao(self, a):
        if a < 0:
            raise ValueError("Não é possível aplicar raiz em números negativos.")
        return round(a ** 0.5, 2)