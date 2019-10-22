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
        for(var i = 0; i < arr.length; i++) { new_arr.push( new THREE.MeshLambertMaterial( {color : arr[ i ] }  ) ) }
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
        function CustomSinCurve( scale ) { THREE.Curve.call( this ); this.scale = ( scale === undefined ) ? 1 : scale; }
        
        CustomSinCurve.prototype = Object.create( THREE.Curve.prototype );
        CustomSinCurve.prototype.constructor = CustomSinCurve;
        
        CustomSinCurve.prototype.getPoint = function ( t ) {
            var tx = t;
            var ty = 1;
            var tz = 1;
            return new THREE.Vector3( tx, ty, tz ).multiplyScalar( this.scale );
            
        };
        
        var path = new CustomSinCurve( 10 );
        var geometry = new THREE.TubeGeometry( path, 20, 2, 8, true );
        geometry.scale(0.1,0.2,0.2)
        
        var t2 = new THREE.Matrix4().makeRotationFromEuler ( new  THREE.Euler(0, 0, 3.1415 * 0.5, 'XYZ' ) )
        var t3 = new THREE.Matrix4().makeTranslation(2.0, -1.0, -2.0)
        geometry.applyMatrix( t2 );
        geometry.applyMatrix( t3 );
        return geometry
    }
    
    function pyramid(width, length, height)
    {
        var geometry = new THREE.Geometry();
        
        geometry.vertices = [
                             new THREE.Vector3( 0, 0, 0 ),
                             new THREE.Vector3( 0, 1, 0 ),
                             new THREE.Vector3( 1, 1, 0 ),
                             new THREE.Vector3( 1, 0, 0 ),
                             new THREE.Vector3( 0.5, 0.5, 1 )
                             ];
        
        geometry.faces = [
                          new THREE.Face3( 0, 1, 2 ),
                          new THREE.Face3( 0, 2, 3 ),
                          new THREE.Face3( 1, 0, 4 ),
                          new THREE.Face3( 2, 1, 4 ),
                          new THREE.Face3( 3, 2, 4 ),
                          new THREE.Face3( 0, 3, 4 )
                          ];
        var transformation = new THREE.Matrix4().makeScale( width, length, height );
        var t2 = new THREE.Matrix4().makeRotationFromEuler ( new  THREE.Euler( 3.1415 + 3.1415 * 0.5, 0, 0, 'XYZ' ) )
        var t3 = new THREE.Matrix4().makeTranslation(-0.5, 0.15, 0.5)
        geometry.applyMatrix( transformation );
        geometry.applyMatrix( t2 );
        geometry.applyMatrix( t3 );
        geometry.computeFaceNormals ()
        return geometry
    }
    var fak_0_torus = 1.0
    var fak_1_torus = 0.2
    
    var fak_0_plane = 1.0
    
    var geo_box = new THREE.BoxGeometry(1.0, 1.0, 1.0);
    geo_box.translate(0.0, 0.25, 0.0)
    var geo_sphere = new THREE.SphereGeometry( 1.0, 32, 32);
    geo_sphere.translate(0.0, 0.25, 0.0)
    var geo_cone = new THREE.ConeGeometry( 1.0, 1.0, 32);
    geo_cone.translate(0.0, 0.25, 0.0)
    var geo_cylinder = new THREE.CylinderGeometry( 1.0, 1.0, 1, 32);
    geo_cylinder.translate(0.0, 0.25, 0.0)
    var geo_plane = new THREE.PlaneGeometry( 1 * fak_0_plane, 1 * fak_0_plane, 1 * fak_0_plane );
    geo_plane.translate(0.0, 0.25, 0.0)
    var geo_pyramid = pyramid(1.0, 1.0, 1.0)
    var geo_torus = new THREE.TorusGeometry( 1.0 * fak_0_torus, 0.6 * fak_1_torus, 16, 100 );
    var t2 = new THREE.Matrix4().makeRotationFromEuler ( new  THREE.Euler( 3.1415 + 3.1415 * 0.5, 0, 0, 'XYZ' ) )
    geo_torus.applyMatrix( t2 );
    var geo_tube = calc_tube_geo()
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
            use_geo = geo_cylinder
        }
        else if (type_value == 4)
        {
            use_geo = geo_plane
        }
        else if (type_value == 5)
        {
            use_geo = geo_pyramid
        }
        else if ( type_value == 6)
        {
            use_geo = geo_torus
        }
        else if ( type_value == 7 )
        {
            use_geo = geo_tube
        }
        
        //v4_color[color_ix]
        var mm = v_material[ color_ix ]
        var o = new THREE.Mesh( use_geo,  mm );
        
        var n = f_position( v3_pos[pos_ix] )
        o.position.x = n.x
        o.position.y = n.y
        o.position.z = n.z
        
        var scale_value = v3_scale[scale_ix]
        o.scale.x = scale_value.x * 0.5
        o.scale.y = scale_value.y * 0.5
        o.scale.z = scale_value.z * 0.5
        
        var rotation_value = v3_rot[rot_ix]
        o.rotation.x = rotation_value.x
        o.rotation.y = rotation_value.y
        o.rotation.z = rotation_value.z
        
        scene.add( o )
    }
}
