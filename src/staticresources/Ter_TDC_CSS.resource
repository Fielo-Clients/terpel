input {
	border-color: #8497B0;
	border-width: 1px;
	border-radius: 4px;
	display: inline-block;
	padding-left: 15px;
	box-sizing: border-box;
	font-size: 14px;
}

label {
	display: inline-block;
	font-size: 15px;
}

label.titulos {
	width: 34%;
	text-align: left;
	font-weight: bold;
}

.boton {
	background: #AFAFAF;
    border: none;
    color: white;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 15px;
    outline: none;
    cursor: pointer;
    width: 30%;
    padding-top: 10px;
    padding-bottom: 10px;
    margin-left: 2%;
}

.boton.menuBtn {
	width: 22%;
}

.boton:active {
	background-color: #F18C55;
}

.boton.clicked {
	background-color: #F18C55;
}

.menu {
	background-color: #D9D9D9;
	margin-top: 35px;
}

.logoAlToque {
	margin: auto;
    display: inherit;
    width: 1018px;
    height: 412px;
}

h1 {
	font-size: 25px;
	display: block;
	padding-left: 20px;
	padding-top: 20px;
}

.fechaCls {
	display: block;
    font-size: 12px;
    margin-top: 5px;
    padding-left: 20px;
    font-style: italic;
}

.logoTerpelHome {
	float: right;
	margin-right: 10px;
	margin-top: 10px;
}

.contentAcumular {
	text-align: center;
	margin: auto;
	width: 50%;
	margin-top: 100px;
}

.contentAcumular .internalDiv {
	margin-top: 10px;
}

#documento {
	margin-top: 10px;
}

.formBtns {
	text-align: right;
    margin-top: 100px;
}

.formBtns.btnsCenter {
	text-align: center;
}

.subtitle {
	margin-top: 10px;
	font-weight: bold;
	display: block;
}

.result {
	display: block;
	margin-top: 10px;
	margin-bottom: 100px;
}

.styled-select.slate {
	background: white;
    display: inline;
}

.styled-select.slate select {
	background: transparent;
	border-color: #8497B0;
	border-width: 1px;
	border-radius: 4px;
	border-style: solid;
	font-size: 14px;
	width: 64%;
	height: 32px;
}

.fieldValue {
	width: 65%;
	height: 25px;
}

.facturaFields {
	margin-top: 50px; 
}

.boldTxt {
	font-weight: bold;
}

/*Loading css*/
.loader {
  border: 16px solid #f3f3f3;
  border-radius: 50%;
  border-top: 16px solid #F18C55;
  width: 120px;
  height: 120px;
  -webkit-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
  margin: 10% auto;
}

@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}