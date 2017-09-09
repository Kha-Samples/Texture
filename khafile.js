let project = new Project('TextureTest');

project.addAssets('Assets/**');
project.addShaders('Sources/Shaders/**');
project.addSources('Sources');

resolve(project);
