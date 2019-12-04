var contractAddress = "0x51fd8D728d1fF3471D8870ba7d767E73f3c34126";
var provider = new ethers.providers.Web3Provider(web3.currentProvider);
var signer = provider.getSigner();
var contract = new ethers.Contract(contractAddress, contractAbi, signer);

function calculoremuneracaoFinal() {    
    var remuneracaoFinal = document.getElementById("remuneracaoFinal");
    console.log("remuneracaoFinal - submitting the request");     
    contract.calculoremuneracaoFinal()
    .then( (resultFromContract) => {
        console.log("remuneracaoFinal - result is", resultFromContract);
        boxBalance.innerHTML = resultFromContract;
    })
    .catch( (err) => {
        console.error(err);
    });
}

function pagto() {
    var motivation = document.frmPayment.motivation.value;
    var boxCommStatus = document.getElementById("pagto");
    boxCommStatus.innerHTML = "Sending transaction...";
    var additionalSettings = {
        value: ethers.utils.parseUnits(amount)
    }; 
    contract.pay(motivation, additionalSettings)
    .then( (tx) => {
        console.log("executePayment - Transaction ", tx);   
        boxCommStatus.innerHTML = "Transaction sent. Waiting for the result...";
        tx.wait()
        .then( (resultFromContract) => {
            console.log("executePayment - the result was ", resultFromContract);
            getContractBalance();
            boxCommStatus.innerHTML = "Transaction executed.";
        })        
        .catch( (err) => {
            console.error("executePayment - after tx being mint");
            console.error(err);
            boxCommStatus.innerHTML = "Algo saiu errado: " + err.message;
        })
    })
    .catch( (err) => {
        console.error("executePayment - tx has been sent");
        console.error(err);
        boxCommStatus.innerHTML = "Something went wrong: " + err.message;
    })
}