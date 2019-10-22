function onWindowResize()
{
      	camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( window.innerWidth, window.innerHeight );
}

function generateRandomVector3_shape0000()
{
  var x = Math.random(-50, 50)
  x = -50 + 100 * x
  
  var y = Math.random(-50, 50)
  y = -50 + 100 * y
  
  var z = Math.random(-50, 50)
  z = -50 + 100 * z
  
  y = 40 + Math.sin(x * 0.1 * z* 0.1)*10

  var vertex = new THREE.Vector3();
  vertex.x = x;
  vertex.y = y;
  vertex.z = z;
  return vertex;
}