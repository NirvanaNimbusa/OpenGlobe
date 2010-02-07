﻿#region License
//
// (C) Copyright 2009 Patrick Cozzi and Deron Ohlarik
//
// Distributed under the Boost Software License, Version 1.0.
// See License.txt or http://www.boost.org/LICENSE_1_0.txt.
//
#endregion

using OpenTK;

namespace MiniGlobe.Renderer
{
    internal class LightPropertiesDrawAutomaticUniformFactory : DrawAutomaticUniformFactory
    {
        #region DrawAutomaticUniformFactory Members

        public override string Name
        {
            get { return "mg_DiffuseSpecularAmbientShininess"; }
        }

        public override DrawAutomaticUniform Create(Uniform uniform)
        {
            return new LightPropertiesDrawAutomaticUniform(uniform);
        }

        #endregion
    }
}