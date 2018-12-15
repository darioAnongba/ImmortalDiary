var ImmortalDiary = artifacts.require("./ImmortalDiary.sol");

module.exports = function(deployer, network, accounts) {
  const name = "The Immortal Diary of Dario and Nati"
  const description = "Immortal Diary of Dario Anongba Varela and Nativity Carol. Most important moments of our live. Use it wisely, as you cannot go back"

  if(network === 'mainnet') {
    deployer.deploy(ImmortalDiary, name, description, {overwrite: false})
  } else {
    deployer.deploy(ImmortalDiary, name, description)
  }

  console.log('Accounts: ', accounts)
};
