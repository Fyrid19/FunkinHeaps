package engine.display.sprite.animation.animate;

extern typedef SpritemapJson =
{
	ATLAS:
	{
		SPRITES:Array<SpriteJson>
	},
	meta:SpritemapMeta
}

extern typedef SpritemapMeta =
{
	app:String,
	version:String,
	image:String,
	format:String,
	size:
	{
		w:Int, h:Int
	},
	resolution:String
}

extern typedef SpriteJson =
{
	SPRITE:
	{
		name:String, x:Float, y:Float, w:Float, h:Float, rotated:Bool
	}
}

extern typedef PointJson =
{
	x:Float,
	y:Float
}

abstract MatrixJson(Array<Float>) from Array<Float>
{
	public var a(get, never):Float;
	public var b(get, never):Float;
	public var c(get, never):Float;
	public var d(get, never):Float;
	public var tx(get, never):Float;
	public var ty(get, never):Float;

	public static function resolve(input:Dynamic):MatrixJson
	{
		var mat2D:Null<MatrixJson> = input.MX ?? input.Matrix;
		if (mat2D != null)
			return mat2D;

		var m3d:Dynamic = input.M3D ?? input.Matrix3D;
		if (m3d != null)
		{
			var mat3D:Array<Float>;

			if (m3d is Array)
			{
				mat3D = m3d;
			}
			else
			{
				mat3D = [
					m3d.m00, m3d.m01, m3d.m02, m3d.m03, m3d.m10, m3d.m11, m3d.m12, m3d.m13, m3d.m20, m3d.m21, m3d.m22, m3d.m23, m3d.m30, m3d.m31, m3d.m32,
					m3d.m33
				];
			}

			return from3Dto2D(mat3D);
		}

		// legacy 2018 texture atlas
		var pos:PointJson = input.POS ?? input.Position;
		if (pos != null)
		{
			return [1, 0, 0, 1, pos.x, pos.y];
		}

		return [1, 0, 0, 1, 0, 0];
	}

	public static function from3Dto2D(mat3D:Array<Float>):Array<Float>
	{
		final hasPerspective:Bool = (mat3D[3] != 0) || (mat3D[7] != 0) || (mat3D[11] != 0) || (mat3D[15] != 1);
		if (!hasPerspective)
			return [mat3D[0], mat3D[1], mat3D[4], mat3D[5], mat3D[12], mat3D[13]];

		var points:Array<Array<Float>> = [[0.0, 0.0], [1.0, 0.0], [0.0, 1.0]];
		var transformed:Array<Array<Float>> = [];

		for (p in points)
		{
			var x = p[0];
			var y = p[1];
			var z = mat3D[3] * x + mat3D[7] * y + mat3D[15];
			transformed.push([
				mat3D[0] * x + mat3D[4] * y + mat3D[12] / z,
				mat3D[1] * x + mat3D[5] * y + mat3D[13] / z
			]);
		}

		var p0:Array<Float> = transformed[0];
		var p1:Array<Float> = transformed[1];
		var p2:Array<Float> = transformed[2];

		var a:Float = p1[0] - p0[0];
		var b:Float = p1[1] - p0[1];
		var c:Float = p2[0] - p0[0];
		var d:Float = p2[1] - p0[1];
		var tx:Float = p0[0];
		var ty:Float = p0[1];

		return [a, b, c, d, tx, ty];
	}

	extern public inline function toMatrix():h2d.col.Matrix
	{
        var matrix:h2d.col.Matrix = new h2d.col.Matrix();
        matrix.a = a;
        matrix.b = b;
        matrix.c = c;
        matrix.d = d;
        matrix.x = tx;
        matrix.y = ty;

		return matrix;
	}

	extern inline function get_a()
		return this[0];

	extern inline function get_b()
		return this[1];

	extern inline function get_c()
		return this[2];

	extern inline function get_d()
		return this[3];

	extern inline function get_tx()
		return this[4];

	extern inline function get_ty()
		return this[5];
}


extern abstract AtlasInstanceJson(Dynamic)
{
	public var N(get, never):String;
	public var MX(get, never):MatrixJson;

	inline function get_N()
		return this.N ?? this.name;
    inline function get_MX()
		return MatrixJson.resolve(this);
}


extern abstract ElementJson(Dynamic)
{
	public var ASI(get, never):Null<AtlasInstanceJson>;

	inline function get_ASI()
		return this.ASI ?? this.ATLAS_SPRITE_instance;
}

extern abstract FrameJson(Dynamic)
{
    public var N(get, never):String;
    public var I(get, never):Int;
    public var DU(get, never):Int;
    public var E(get, never):Array<ElementJson>;

    inline function get_N()
		return this.N ?? this.name;
    inline function get_I()
		return this.I ?? this.index;
    inline function get_DU()
		return this.DU ?? this.duration;
    inline function get_E()
		return this.E ?? this.elements;
}

extern abstract LayerJson(Dynamic)
{
	public var LN(get, never):String;
    public var FR(get, never):Array<FrameJson>;

	inline function get_LN()
		return this.LN ?? this.Layer_name;
    inline function get_FR()
		return this.FR ?? this.Frames;
}


extern abstract TimelineJson(Dynamic)
{
	public var L(get, never):Array<LayerJson>;

	inline function get_L()
		return this.L ?? this.LAYERS;
}

extern abstract AnimationMetaJson(Dynamic)
{
    public var FRT(get, never):Float;
    
    inline function get_FRT()
        return this.FRT ?? this.framerate;
}

extern abstract AnimJson(Dynamic)
{
    public var N(get, never):String;
    public var SN(get, never):String;
    public var TL(get, never):TimelineJson;
    
    inline function get_N()
        return this.N ?? this.name;
    inline function get_SN()
        return this.SN ?? this.SYMBOL_name;
    inline function get_TL()
        return this.TL ?? this.TIMELINE;
}

extern abstract AnimationJson(Dynamic)
{
    public var AN(get, never):AnimJson;
    public var MD(get, never):AnimationMetaJson;
    
    inline function get_AN()
        return this.AN ?? this.ANIMATION;
    inline function get_MD()
        return this.MD ?? this.metadata;
}