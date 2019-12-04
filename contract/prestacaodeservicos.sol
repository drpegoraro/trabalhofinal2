pragma solidity 0.5.13;
   
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
    }

    function pagto (uint remuneracaoFinal) public payable
     {
        require (msg.value == remuneracaoFinal);
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
