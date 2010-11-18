#version 330
//
// (C) Copyright 2010 Patrick Cozzi and Kevin Ring
//
// Distributed under the Boost Software License, Version 1.0.
// See License.txt or http://www.boost.org/LICENSE_1_0.txt.
//

in vec2 position;

out vec2 fineUvFS;
out vec2 coarseUvFS;
out vec3 positionToLightFS;
out float alphaFS;

uniform mat4 og_modelViewPerspectiveMatrix;
uniform vec3 u_sunPositionRelativeToViewer;
uniform vec2 u_patchOriginInClippedLevel;
uniform vec2 u_levelScaleFactor;
uniform vec2 u_levelZeroWorldScaleFactor;
uniform vec2 u_levelOffsetFromWorldOrigin;
uniform vec2 u_fineLevelOriginInCoarse;
uniform vec2 u_viewPosInClippedLevel;
uniform vec2 u_unblendedRegionSize;
uniform vec2 u_oneOverBlendedRegionSize;
uniform vec2 u_fineTextureOrigin;
uniform float u_heightExaggeration;
uniform float u_oneOverClipmapSize;
uniform bool u_useBlendRegions;
uniform sampler2D og_texture0;    // finer height map
uniform sampler2D og_texture1;    // coarser height map

float SampleHeight(vec2 levelPos)
{
	fineUvFS = (levelPos + u_fineTextureOrigin) * u_oneOverClipmapSize;
	coarseUvFS = (levelPos * 0.5 + u_fineLevelOriginInCoarse) * u_oneOverClipmapSize;

    if (u_useBlendRegions)
    {
	    vec2 alpha = clamp((abs(levelPos - u_viewPosInClippedLevel) - u_unblendedRegionSize) * u_oneOverBlendedRegionSize, 0, 1);
	    alphaFS = max(alpha.x, alpha.y);
    }
    else
    {
        alphaFS = 0.0;
    }

	float fineHeight = texture(og_texture0, fineUvFS).r;
	float coarseHeight = texture(og_texture1, coarseUvFS).r;
	return mix(fineHeight, coarseHeight, alphaFS) * u_heightExaggeration;
}

void main()
{
	vec2 levelPos = position + u_patchOriginInClippedLevel;

    float height = SampleHeight(levelPos);
	vec2 worldPos = levelPos * u_levelScaleFactor * u_levelZeroWorldScaleFactor + u_levelOffsetFromWorldOrigin;
	vec3 displacedPosition = vec3(worldPos, height);

    positionToLightFS = u_sunPositionRelativeToViewer - displacedPosition;

    gl_Position = og_modelViewPerspectiveMatrix * vec4(displacedPosition, 1.0);
}
