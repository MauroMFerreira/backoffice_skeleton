<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(document).ready(function(){
  $(".b1").click(function(){
    $.get("http://localhost/backoffice_skeleton/README.md", function(data, status){
      alert("Data: " + data + "\nStatus: " + status);
    });
  });
});
$(".b2").click(function(){
  $.post("http://localhost/backoffice_skeleton/README.md",
  {
    name: "Donald Duck",
    city: "Duckburg"
  },
  function(data, status){
    alert("Data: " + data + "\nStatus: " + status);
  });
}); 
</script>
</head>
<body>

<button class="b1">Send an HTTP GET request to a page and get the result back</button>
<button class="b2">Send an HTTP POST request to a page and get the result back</button>

</body>
</html>

