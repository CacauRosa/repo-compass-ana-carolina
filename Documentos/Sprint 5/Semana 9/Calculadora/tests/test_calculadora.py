"""
Foi utilizado o ChatGPT para gerar valores de teste que cobrissem a maior parte de
combinações numéricas possíveis para a realização de cada operação
"""

import pytest
from calculadora.calculadora import Calculadora

calculadora = Calculadora()


@pytest.mark.basicas
@pytest.mark.parametrize("a, b, esperado",[
    (0, 15.5, 15.5),
    (-3, 8, 5),
    (22, 11.2, 33.2),
    (5, 0, 5),
    (13, -7, 6),
    (8, 6, 14)
])
def test_adicao(a,b,esperado):
    assert calculadora.adicao(a,b) == esperado


@pytest.mark.basicas
@pytest.mark.parametrize("a, b, esperado",[
    (0, 15.5, -15.5),
    (-3, 8, -11),
    (22, 11.2, 10.8),
    (5, 0, 5),
    (13, -7, 20),
    (8, 6, 2)
])
def test_subtracao(a,b,esperado):
    assert calculadora.subtracao(a,b) == esperado


@pytest.mark.basicas
@pytest.mark.parametrize("a, b, esperado",[
    (0, 15.5, 0.0),
    (-3, 8, -24),
    (22, 11.2, 246.4),
    (5, 0, 0),
    (13, -7, -91),
    (8, 6, 48)
])
def test_multiplicacao(a,b,esperado):
    assert calculadora.multiplicacao(a,b) == esperado


@pytest.mark.basicas
@pytest.mark.excecoes
@pytest.mark.parametrize("a, b, esperado",[
    (10, 2, 5),
    (-20, 5, -4),
    (0, 15, 0),
    (7.5, 2.5, 3.0),
    (9, -3, -3),
    (4, 3, 1.33)
])
def test_divisao(a,b,esperado):
    assert calculadora.divisao(a,b) == esperado
def test_divisao_por_zero():
    with pytest.raises(ZeroDivisionError):
        calculadora.divisao(10,0)
def test_divisao_por_zero_verificacao_mensagem():
    with pytest.raises(ZeroDivisionError) as exec_info:
        calculadora.divisao(10,0)
    assert "Não é possível dividir por zero." in str(exec_info)


@pytest.mark.adicionais
@pytest.mark.parametrize("a, b, esperado",[
    (2, 3, 8),
    (5, 0, 1),
    (-3, 3, -27),
    (0, 4, 0),
    (0.1, 2, 0.01),
    (6, 1, 6)
    ])
def test_potenciacao(a, b, esperado):
    assert calculadora.potenciacao(a, b) == esperado


@pytest.mark.adicionais
@pytest.mark.excecoes
@pytest.mark.parametrize("a, esperado",[
    (0, 0),
    (4, 2),
    (9, 3),
    (64, 8),
    (2.25, 1.5),
    (54, 7.35)
    ])
def test_radiciacao(a, esperado):
    assert calculadora.radiciacao(a) == esperado
def test_radiciacao_negativa():
    with pytest.raises(ValueError):
        calculadora.radiciacao(-9)
def test_radiciacao_negativa_verificacao_mensagem():
    with pytest.raises(ValueError) as exec_info:
        calculadora.radiciacao(-9)
    assert "Não é possível aplicar raiz em números negativos." in str(exec_info)