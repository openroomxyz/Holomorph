function RandomInt(min, max)
{
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function addLights()
{
    var ambientLight = new THREE.AmbientLight( 0x101010 );
    scene.add( ambientLight );
    
    var lights = [];
    lights[ 0 ] = new THREE.PointLight( 0xffffff, 1, 0 );
    lights[ 1 ] = new THREE.PointLight( 0xffffff, 1, 0 );
    lights[ 2 ] = new THREE.PointLight( 0xffffff, 1, 0 );
    
    lights[ 0 ].position.set( 0, 200, 0 );
    lights[ 1 ].position.set( 100, 200, 100 );
    lights[ 2 ].position.set( - 100, - 200, - 100 );
    
    scene.add( lights[ 0 ] );
    scene.add( lights[ 1 ] );
    scene.add( lights[ 2 ] );
}

function htest()
{
    addLights()
    var el_arr = data.el //[position, rotation, scale, type, color, timestamp]
    var pos_arr = data.pos;
    var rot_arr = data.rot;
    var scale_arr = data.scale;
    var color_arr = data.color;
    
    function transform1(arr)
    {
        var new_arr = []
        for( var i = 0; i < Math.floor(arr.length / 3); i++)
        {
            new_arr.push( new THREE.Vector3( arr[i * 3], arr[i * 3 + 1], arr[i * 3 + 2] ))
        }
        return new_arr
    }
    function transform2(arr)
    {
        var new_arr = []
        for(var i = 0; i < Math.floor(arr.length / 4); i++)
        {
            new_arr.push( new THREE.Vector4( arr[i * 4], arr[i * 4 + 1], arr[i * 4 + 2], arr[i * 4 + 3]))
        }
        return new_arr
    }
    function transform3(arr)
    {
        var new_arr = []
        for(var i = 0; i < arr.length; i++)
        {
            new_arr.push( new THREE.Color(arr[i].x, arr[i].y, arr[i].z) )
        }
        return new_arr
    }
    
    function transformColorToMaterials(arr)
    {
        var new_arr = []
        for(var i = 0; i < arr.length; i++)
        {
            //new_arr.push( new THREE.MeshPhongMaterial( {color : arr[ i ] }  ) )
            new_arr.push( new THREE.MeshLambertMaterial( {color : arr[ i ] }  ) )
        }
        return new_arr
    }
    
    
    
    var v3_pos = transform1(pos_arr)
    var v3_rot = transform1(rot_arr)
    var v3_scale = transform1(scale_arr)
    var v_material = transformColorToMaterials( transform3( transform2(color_arr) ) )
    
    function f_position(v)
    {
        return new THREE.Vector3(v.x * 50, v.y * 50, v.z * 50)
    }
    
    
    
    function calc_tube_geo()
    {
        function CustomSinCurve( scale ) {
            
            THREE.Curve.call( this );
            
            this.scale = ( scale === undefined ) ? 1 : scale;
            
        }
        
        CustomSinCurve.prototype = Object.create( THREE.Curve.prototype );
        CustomSinCurve.prototype.constructor = CustomSinCurve;
        
        CustomSinCurve.prototype.getPoint = function ( t ) {
            
            var tx = t * 3 - 1.5;
            var ty = Math.sin( 2 * Math.PI * t );
            var tz = 0;
            
            return new THREE.Vector3( tx, ty, tz ).multiplyScalar( this.scale );
            
        };
        
        var path = new CustomSinCurve( 10 );
        var geometry = new THREE.TubeGeometry( path, 20, 2, 8, false );
        return geometry
    }
    
    var geo_box = new THREE.BoxGeometry(1, 1, 1);
    var geo_sphere = new THREE.SphereGeometry( 1, 32, 32);
    var geo_cone = new THREE.ConeGeometry( 1, 1, 32); //(radius, height, radialSegments, heightSegments, openEnded, thetaStart, thetaLength)
    var geo_cylinder = new THREE.CylinderGeometry( 1, 1, 1, 32); //CylinderGeometry(radiusTop, radiusBottom, height, radialSegments, heightSegments, openEnded, thetaStart, thetaLength)
    var geo_plane = new THREE.PlaneGeometry( 1, 1, 1 ); //PlaneGeometry(width, height, widthSegments, heightSegments)
    var geo_pyramid = new THREE.TetrahedronGeometry(1, 0) //TetrahedronGeometry(radius, detail)
    var geo_torus = new THREE.TorusGeometry( 10, 3, 16, 100 ); //TorusGeometry(radius, tube, radialSegments, tubularSegments, arc)
    var geo_tube = geo_torus//calc_tube_geo() //for now
    
    for( var i = 0; i < el_arr.length; i++)
    {
        var one_el = el_arr[i]
        
        var pos_ix = one_el.v[0]
        var rot_ix = one_el.v[1]
        var scale_ix = one_el.v[2]
        var type_value = one_el.v[3]
        var color_ix = one_el.v[4]
        var time_value = one_el.v[5]
        
        //type_value
        var use_geo = geo_box
        if( type_value == 0)
        {
            use_geo = geo_sphere
        }
        else if ( type_value == 1)
        {
            use_geo = geo_box
        }
        else if (type_value == 2)
        {
            use_geo = geo_cone
        }
        else if (type_value == 3)
        {
            use_geo = geo_plane
        }
        else if (type_value == 4)
        {
            use_geo = geo_pyramid
        }
        else if (type_value == 5)
        {
            use_geo = geo_torus
        }
        else if ( type_value == 6)
        {
            use_geo = geo_tube
        }
        
        //v4_color[color_ix]
        var mm = v_material[ color_ix ] // new THREE.MeshPhongMaterial( {color : v4_color[color_ix]}  )
        var o = new THREE.Mesh( use_geo,  mm );
        
        var n = f_position( v3_pos[pos_ix] )
        o.position.x = n.x
        o.position.y = n.y
        o.position.z = n.z
        
        var scale_value = v3_scale[scale_ix]
        o.scale.x = scale_value.x
        o.scale.y = scale_value.y
        o.scale.z = scale_value.z
        
        var rotation_value = v3_rot[rot_ix]
        o.rotation.x = rotation_value.x
        o.rotation.y = rotation_value.y
        o.rotation.z = rotation_value.z
        
        scene.add( o )
    }
}
