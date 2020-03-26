<template>
  <div id="app">
    <!-- <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>-->
    ユーザー名：
    <br />
    <input v-model="UserName" />
    <br />Eメールアドレス：
    <br />
    <input v-model="UserEmail" />
    <br />
    <p>
      <button @click="registerInfo()">登録</button>
    </p>
    <br />
    <!-- <p><button onclick="registerInfo()">登録</button></p><br> -->
    アカウント番号：
    <br />
    <input v-model="NumAccount" />
    <br />
    <p>
      <button @click="showInfo()">アカウント情報表示</button>
    </p>
    <br />
    <!-- <p><button onclick="showInfo()">アカウント情報表示</button></p><br> -->
    <ul id="AccountInfo"></ul>
  </div>
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import Web3 from "web3";

var gCoinbase = null;
var gWeb3 = null;
const address = "0xc5Dd23e8E8044A44C7c332C6f06eE2afc51671BD";
var abi = [
  {
    constant: false,
    inputs: [
      {
        name: "_name",
        type: "string"
      },
      {
        name: "_email",
        type: "string"
      }
    ],
    name: "register",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    inputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "constructor"
  },
  {
    constant: true,
    inputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    name: "accounts",
    outputs: [
      {
        name: "addr",
        type: "address"
      },
      {
        name: "name",
        type: "string"
      },
      {
        name: "email",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "numAccount",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  }
];

export default {
  name: "App",
  data: () => ({
    UserName: "",
    UserEmail: "",
    NumAccount: ""
  }),
  created() {
    window.ethereum.enable();
    //const web3 = new Web3(window.web3.currentProvider);
    if (window.web3) {
      gWeb3 = new Web3(window.web3.currentProvider);
      gWeb3.eth.getAccounts().then(function(accounts) {
        gCoinbase = accounts[0];
        console.log("accounts is " + accounts[0]);
        console.log("gCoinbase is " + gCoinbase);
      });
    }
    console.log("coinbase is " + gCoinbase);
  },

  methods: {
    registerInfo() {
      console.log("★★registerInfo");
      const contract = new gWeb3.eth.Contract(abi, address);
      // コントラクトの呼び出し
      contract.methods
        .register(this.UserName, this.UserEmail)
        .send({ from: gCoinbase })
        .on("receipt", function() {
          //    .on("receipt", function(receipt){
          console.log("success");
        })
        .on("error", function() {
          //    .on("error", function(error){
          console.log("error");
        });
    },
    showInfo() {
      // 表示されている情報を空にする
      var sl = document.getElementById("AccountInfo");
      while (sl.lastChild) {
        sl.removeChild(sl.lastChild);
      }

      // 変数を取得する
      const contract = new gWeb3.eth.Contract(abi, address);
      contract.methods
        .accounts(this.NumAccount)
        .call()
        .then(function(account) {
          for (var i = 0; i < Object.keys(account).length / 2; i++) {
            var li = document.createElement("li");
            li.textContent =
              Object.keys(account)[i + Object.keys(account).length / 2] +
              " : " +
              account[i];
            document.getElementById("AccountInfo").appendChild(li);
          }
        });
    }
  }
  // components: {
  //   HelloWorld
  // }
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
