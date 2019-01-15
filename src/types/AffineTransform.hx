/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package types;

class AffineTransform
{
    /* Column major
    [ m00 m10  0]
    [ m01 m11  0]
    [ m02 m12  1]
    * x   y      */
    public var m00: Float = 1.0; // a
    public var m01: Float = 0.0; // b
    public var m02: Float = 0.0; // x
    public var m10: Float = 0.0; // c
    public var m11: Float = 1.0; // d
    public var m12: Float = 0.0; // y

    @:deprecated
    public var a(get, set): Float;

    inline private function set_a(value: Float): Float
    {m00 = value; return m00;}

    inline private function get_a(): Float
    {return m00;}

    @:deprecated
    public var b(get, set): Float;

    inline private function set_b(value: Float): Float
    {m10 = value; return m10;}

    inline private function get_b(): Float
    {return m10;}

    @:deprecated
    public var c(get, set): Float;

    inline private function set_c(value: Float): Float
    {m01 = value; return m01;}

    inline private function get_c(): Float
    {return m01;}

    @:deprecated
    public var d(get, set): Float;

    inline private function set_d(value: Float): Float
    {m11 = value; return m11;}

    inline private function get_d(): Float
    {return m11;}

    @:deprecated("tx is deprecated. Use worldX of Transform2DComponent instead!")
    public var tx(get, set): Float;

    inline private function set_tx(value: Float): Float
    {m02 = value; return m02;}

    inline private function get_tx(): Float
    {return m02;}

    @:deprecated("ty is deprecated. Use worldY of Transform2DComponent instead!")
    public var ty(get, set): Float;

    inline private function set_ty(value: Float): Float
    {m12 = value; return m12;}

    inline private function get_ty(): Float
    {return m12;}

    @:deprecated
    public function concat(right: AffineTransform): Void
    {
        preMultiply(right);
    }

    /** Constructs an identity matrix. */

    public function new(): Void
    {
    }

    /** Sets this matrix to the identity matrix */

    inline public function setIdentity(): Void
    {
        m00 = 1.0;
        m01 = 0.0;
        m02 = 0.0;
        m10 = 0.0;
        m11 = 1.0;
        m12 = 0.0;
    }

    /** Copies the values from the provided affine matrix to this matrix.
	 * @param other The affine matrix to copy.
	 **/

    inline public function set(other: AffineTransform): Void
    {
        m00 = other.m00;
        m01 = other.m01;
        m02 = other.m02;
        m10 = other.m10;
        m11 = other.m11;
        m12 = other.m12;
    }

    /** Sets this matrix to a concatenation of translation and scale. It is a more efficient form for:
	 * <code>idt().translate(x, y).scale(scaleX, scaleY)</code>
	 * @param x The translation in x.
	 * @param y The translation in y.
	 * @param scaleX The scale in y.
	 * @param scaleY The scale in x.
	 **/

    inline public function setTranslationScale(x: Float, y: Float, scaleX: Float, scaleY: Float): Void
    {
        m00 = scaleX;
        m01 = 0.0;
        m02 = x;
        m10 = 0.0;
        m11 = scaleY;
        m12 = y;
    }

    /** Sets this matrix to a concatenation of translation, rotation and scale. It is a more efficient form for:
	 * <code>idt().translate(x, y).rotateRad(radians).scale(scaleX, scaleY)</code>
	 * @param x The translation in x.
	 * @param y The translation in y.
	 * @param radians The angle in radians.
	 * @param scaleX The scale in y.
	 * @param scaleY The scale in x.
	 **/

    inline public function setTranslationRotationScale(x: Float, y: Float, radians: Float, scaleX: Float, scaleY: Float): Void
    {
		m02 = x;
        m12 = y;

		if (radians == 0.0)
        {
            m00 = scaleX;
            m01 = 0.0;
            m10 = 0.0;
            m11 = scaleY;
        }
        else
        {
            var sin = Math.sin(radians);
            var cos = Math.cos(radians);

            m00 = cos * scaleX;
            m01 = -sin * scaleY;

            m10 = sin * scaleX;
            m11 = cos * scaleY;
        }
    }

    /** Same as above, but allows to flip */

    inline public function setTranslationRotationScaleFlip(x: Float, y: Float, radians: Float, scaleX: Float, scaleY: Float, flipX: Bool, flipY: Bool): Void
    {
        m02 = x;
        m12 = y;

		var xSign: Float = flipX ? -1.0 : 1.0;
		var ySign: Float = flipY ? -1.0 : 1.0;

        if (radians == 0.0)
        {
            m00 = scaleX * xSign;
            m01 = 0.0;
            m10 = 0.0;
            m11 = scaleY * ySign;
        }
        else
        {
            var sin = Math.sin(radians);
            var cos = Math.cos(radians);

            m00 = cos * scaleX * xSign;
            m01 = -sin * scaleY * ySign;

            m10 = sin * scaleX * xSign;
            m11 = cos * scaleY * ySign;
        }
    }

	inline public function setTranslationRotationScaleSkewFlip(x: Float, y: Float, radians: Float, scaleX: Float, scaleY: Float, skewX: Float, skewY: Float, flipX: Bool, flipY: Bool): Void
    {
        m02 = x;
        m12 = y;

		var xScale: Float = flipX ? -scaleX : scaleX;
		var yScale: Float = flipY ? -scaleY : scaleY;

        if (radians == 0.0)
        {
            m00 = xScale;
			m11 = yScale;
            m01 = skewX * xScale;
            m10 = skewY * yScale;
        }
        else
        {
            var sin = Math.sin(radians);
            var cos = Math.cos(radians);

            m00 = cos * xScale;
            m01 = -sin * yScale;

            m10 = sin * xScale;
            m11 = cos * yScale;

			var tmp0 = m00 + skewY * m01;
	        var tmp1 = m01 + skewX * m00;
	        m00 = tmp0;
	        m01 = tmp1;

	        tmp0 = m10 + skewY * m11;
	        tmp1 = m11 + skewX * m10;

	        m10 = tmp0;
	        m11 = tmp1;
        }
    }

    inline public function setOrtho(left: Float, right: Float, bottom: Float, top: Float): Void
    {
        var ral: Float = right + left;
        var rsl: Float = right - left;
        var tab: Float = top + bottom;
        var tsb: Float = top - bottom;

        m00 = 2.0 / rsl;
        m01 = 0.0;
        m10 = 0.0;
        m11 = 2.0 / tsb;
        m02 = -ral / rsl;
        m12 = -tab / tsb;
    }

    inline public function get(index: Int): Float
    {
        switch (index)
        {
            case 0: return m00;
            case 1: return m01;
            case 2: return m02;
            case 3: return m10;
            case 4: return m11;
            case 5: return m12;

            default: return 0.0;
        }
    }

    /** Returns rotation of the matrix, in radians.
     **/

    inline public function getRotation(): Float
    {
        return Math.atan2(m01, m00);
    }

    /** Returns x scale of the matrix.
     **/

    inline public function getScaleX(): Float
    {
        return Math.sqrt(m00 * m00 + m01 * m01) * ((m00 > 0.0) ? 1.0 : -1.0);
    }

    /** Returns y scale of the matrix.
     **/

    inline public function getScaleY(): Float
    {
        return Math.sqrt(m10 * m10 + m11 * m11) * ((m11 > 0.0) ? 1.0 : -1.0);
    }

    /** Postmultiplies this matrix by a translation matrix.
	 * @param x The x-component of the translation vector.
	 * @param y The y-component of the translation vector.
	 **/

    inline public function translate(x: Float, y: Float): Void
    {
        m02 += m00 * x + m01 * y;
        m12 += m10 * x + m11 * y;
    }

    /** Premultiplies this matrix by a translation matrix.
	 * @param x The x-component of the translation vector.
	 * @param y The y-component of the translation vector.
	 **/

    inline public function preTranslate(x: Float, y: Float): Void
    {
        m02 += x;
        m12 += y;
    }

    /** Postmultiplies this matrix with a scale matrix.
	 * @param scaleX The scale in the x-axis.
	 * @param scaleY The scale in the y-axis.
	 **/

    inline public function scale(scaleX: Float, scaleY: Float): Void
    {
        m00 *= scaleX;
        m01 *= scaleY;
        m10 *= scaleX;
        m11 *= scaleY;
    }

    /** Premultiplies this matrix with a scale matrix.
	 * @param scaleX The scale in the x-axis.
	 * @param scaleY The scale in the y-axis.
	 **/

    inline public function preScale(scaleX: Float, scaleY: Float): Void
    {
        m00 *= scaleX;
        m01 *= scaleX;
        m02 *= scaleX;
        m10 *= scaleY;
        m11 *= scaleY;
        m12 *= scaleY;
    }

    /** Postmultiplies this matrix with a (counter-clockwise) rotation matrix.
	 * @param radians The angle in radians
	 **/

    inline public function rotate(radians: Float): Void
    {
        if (radians == 0.0) return;

        var cos = Math.cos(radians);
        var sin = Math.sin(radians);

        var tmp00 = m00 * cos + m01 * sin;
        var tmp01 = m00 * -sin + m01 * cos;
        var tmp10 = m10 * cos + m11 * sin;
        var tmp11 = m10 * -sin + m11 * cos;

        m00 = tmp00;
        m01 = tmp01;
        m10 = tmp10;
        m11 = tmp11;
    }

    /** Premultiplies this matrix with a (counter-clockwise) rotation matrix.
	 * @param radians The angle in radians
	 **/

    inline public function preRotate(radians: Float): Void
    {
        if (radians == 0.0) return;

        var cos = Math.cos(radians);
        var sin = Math.sin(radians);

        var tmp00 = cos * m00 - sin * m10;
        var tmp01 = cos * m01 - sin * m11;
        var tmp02 = cos * m02 - sin * m12;
        var tmp10 = sin * m00 + cos * m10;
        var tmp11 = sin * m01 + cos * m11;
        var tmp12 = sin * m02 + cos * m12;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;
        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;
    }

    /** Postmultiplies this matrix by a skew matrix.
	 * @param skewX The shear in x direction.
	 * @param skewY The shear in y direction.
	 **/

    inline public function skew(skewX: Float, skewY: Float): Void
    {
        var tmp0 = m00 + skewY * m01;
        var tmp1 = m01 + skewX * m00;
        m00 = tmp0;
        m01 = tmp1;

        tmp0 = m10 + skewY * m11;
        tmp1 = m11 + skewX * m10;

        m10 = tmp0;
        m11 = tmp1;
    }

    /** Premultiplies this matrix by a skew matrix.
	 * @param skewX The shear in x direction.
	 * @param skewY The shear in y direction.
	 **/

    inline public function preSkew(skewX: Float, skewY: Float): Void
    {
        var tmp00 = m00 + skewX * m10;
        var tmp01 = m01 + skewX * m11;
        var tmp02 = m02 + skewX * m12;
        var tmp10 = m10 + skewY * m00;
        var tmp11 = m11 + skewY * m01;
        var tmp12 = m12 + skewY * m02;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;
        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;
    }

    /** Calculates the determinant of the matrix.
	 * @return The determinant of this matrix. */

    inline public function determinant(): Float
    {
        return m00 * m11 - m01 * m10;
    }

    /** Inverts this matrix given that the determinant is != 0.
	 **/

    inline public function invert(): Void
    {
        var det = determinant();
        if (det == 0.0) return;

        var invDet = 1.0 / det;

        var tmp00 = m11;
        var tmp01 = -m01;
        var tmp02 = m01 * m12 - m11 * m02;
        var tmp10 = -m10;
        var tmp11 = m00;
        var tmp12 = m10 * m02 - m00 * m12;

        m00 = invDet * tmp00;
        m01 = invDet * tmp01;
        m02 = invDet * tmp02;
        m10 = invDet * tmp10;
        m11 = invDet * tmp11;
        m12 = invDet * tmp12;
    }

    /** Postmultiplies this matrix with the provided matrix and stores the result in this matrix. For example:
	 *
	 * <pre>
	 * A.mul(B) results in A := AB
	 * </pre>
	 * @param other Matrix to multiply by.
	 **/

    inline public function multiply(other: AffineTransform): Void
    {
        var tmp00 = m00 * other.m00 + m01 * other.m10;
        var tmp01 = m00 * other.m01 + m01 * other.m11;
        var tmp02 = m00 * other.m02 + m01 * other.m12 + m02;
        var tmp10 = m10 * other.m00 + m11 * other.m10;
        var tmp11 = m10 * other.m01 + m11 * other.m11;
        var tmp12 = m10 * other.m02 + m11 * other.m12 + m12;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;
        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;
    }

    /** Premultiplies this matrix with the provided matrix and stores the result in this matrix. For example:
	 *
	 * <pre>
	 * A.preMul(B) results in A := BA
	 * </pre>
	 * @param other The other Matrix to multiply by
	 **/

    inline public function preMultiply(other: AffineTransform): Void
    {
        var tmp00 = other.m00 * m00 + other.m01 * m10;
        var tmp01 = other.m00 * m01 + other.m01 * m11;
        var tmp02 = other.m00 * m02 + other.m01 * m12 + other.m02;
        var tmp10 = other.m10 * m00 + other.m11 * m10;
        var tmp11 = other.m10 * m01 + other.m11 * m11;
        var tmp12 = other.m10 * m02 + other.m11 * m12 + other.m12;

        m00 = tmp00;
        m01 = tmp01;
        m02 = tmp02;
        m10 = tmp10;
        m11 = tmp11;
        m12 = tmp12;
    }

    inline public function toString(): String
    {
        return "[" + m00 + ", " + m01 + ", " + m02 + ", " + m10 + ", " + m11 + ", " + m12 + "]";
    }
}
