<?php include '../info.php'; ?>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>BD</title>

  <!--[if IE 6]><link href="default_ie6.css" rel="stylesheet" type="text/css" /><![endif]-->

</head>
<body>
	<a href="../index.php"> <- Voltar</a>
	<h1>Cadastrar Evento</h1>
	<form method="POST" action="../controlador.php">
		<label>Data Inicio</label></br>
		<input type="date" name="dataInicio" required></br>
		<label>Data Fim</label></br>
		<input type="date" name="dataFim"></br>
		<label>Descrição</label></br>
		<input type="text" name="descricao" required></br>
		<label>Calendário</label></br>
		<select name="calendario" required>
			<?php
				$result = getCalendario();
				while ($row = pg_fetch_array($result)) {
     				?>
     				<option value="<?php echo $row['dataInicio'].'|'.$row['tipo']; ?>"><?php echo $row['tipo'].' '.$row['dataInicio']; ?></option>
     				<?php
   				}
			 ?>
		</select></br>
		<input name='submit' type="submit" value="Cadastrar Evento">
	</form>
</body>
</html>