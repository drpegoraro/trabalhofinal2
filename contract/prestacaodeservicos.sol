pragma solidity 0.5.12;
   
contract PrestacaoDeServicos
{
    string public prestador;
    string public empresa;
    uint256 public  valorHora;
    uint256 public horasTrabalhadas;
    bool[] public statusPagamento;
    address payable contaPrestador;
    address contaEmpresa;
    bool public pago;
    bool public retirado;
    
    event pagamentoRealizado (uint valor);
    
    constructor (
        string memory nomePrestador,
        string memory nomeEmpresa,
        uint256 valorHoraTrabalho,
        uint256 numeroHorasTrabalhadas,
        address payable ncontaprestador,
        address ncontaempresa
        ) public
        
        {
// require para que o contrato seja limitado a no máximo 66.000 wei
        
        require (valorHoraTrabalho<=300, "O VALOR DA HORA ULTRAPASSOU O LIMITE");
        require (numeroHorasTrabalhadas<=220, "O NÚMERO DE HORAS ULTRAPASSOU O LIMITE");
        require (msg.sender == ncontaempresa, "Operação exclusiva da empresa");
        
        prestador = nomePrestador;
        empresa = nomeEmpresa;
        valorHora = valorHoraTrabalho;
        horasTrabalhadas = numeroHorasTrabalhadas;
        contaPrestador = ncontaprestador;
        contaEmpresa = ncontaempresa;
        }
    
    function calculoremuneracaoFinal () public view returns (uint remuneracaoFinal)
    {
        remuneracaoFinal = valorHora*horasTrabalhadas;

//condição para a ter uma remuneração mínima de 1.000 wei

        if (remuneracaoFinal<1000)
        {    
            remuneracaoFinal = 1000;
            return remuneracaoFinal;
        }
     }
// a duração do contrato é de 365 dias
        
    function vigenciaContrato () public view returns (uint dataInicioContrato, uint dataFinalContrato)
    {
        dataInicioContrato = now;
        dataFinalContrato = dataInicioContrato+365 days;
    }

// coloquei que o vencimento são em 10 dias e se não for cumprido

    function dataVencimento () public view returns (uint vencimento)
    {
       vencimento = now+864000;
       return vencimento;
        
    } 
    
    function pagtoNoPrazo (uint vencimento, uint remuneracaoFinal) public payable
     {
        require (now <= vencimento, "PAGAMENTO NO PRAZO");
        require (msg.value == remuneracaoFinal, "PAGAMENTO SEM MULTA");
        pago = true;
        contaPrestador.transfer(address(this).balance);
        statusPagamento.push(true);
        emit pagamentoRealizado(msg.value);
    }
 
    function pgtoAtrasado (uint vencimento, uint remuneracaoFinal) public payable
    {
        require (now > vencimento, "PAGAMENTO EM ATRASO");
        require (msg.value == remuneracaoFinal+(remuneracaoFinal*20/100), "PAGAMENTO COM MULTA");
        pago = true;
        contaPrestador.transfer(address(this).balance);
        statusPagamento.push(true);
        emit pagamentoRealizado(msg.value);
    }
    
    function saldoNoContrato () public view returns (uint)
    {
        return address(this).balance;
    }
}
