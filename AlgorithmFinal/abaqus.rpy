# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 6.14-2 replay file
# Internal Version: 2014_08_22-16.00.46 134497
# Run by pettlind on Mon Mar 11 08:59:14 2019
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=229.897903442383, 
    height=422.0)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
execfile('model.py', __main__.__dict__)
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
#: Job Job-1: Analysis Input File Processor completed successfully.
#: Job Job-1: Abaqus/Standard completed successfully.
#: Job Job-1 completed successfully. 
session.viewports['Viewport: 1'].assemblyDisplay.setValues(interactions=OFF, 
    constraints=OFF, connectors=OFF, engineeringFeatures=OFF)
o3 = session.openOdb(
    name='C:/Users/pettlind/Documents/GitHub/MyGitFolder/AlgorithmFinal/Job-1.odb')
#: Model: C:/Users/pettlind/Documents/GitHub/MyGitFolder/AlgorithmFinal/Job-1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          6
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.594177, 
    farPlane=0.873694, width=0.471613, height=0.21608, cameraPosition=(
    0.297165, 0.658345, 0.330394), cameraUpVector=(-0.789822, 0.143352, 
    -0.596348), cameraTarget=(0.00411104, 0.000786636, 0.144922))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.582545, 
    farPlane=0.898544, width=0.46238, height=0.21185, cameraPosition=(0.68736, 
    0.265168, 0.254004), cameraUpVector=(-0.459895, 0.554276, -0.69374), 
    cameraTarget=(-0.000927737, 0.00586394, 0.145908))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.564572, 
    farPlane=0.915368, width=0.448115, height=0.205314, cameraPosition=(
    0.474461, 0.495691, 0.439546), cameraUpVector=(-0.381677, 0.371746, 
    -0.846243), cameraTarget=(-0.0001029, 0.00497083, 0.145189))
session.viewports['Viewport: 1'].odbDisplay.basicOptions.setValues(
    averageElementOutput=False)
session.viewports['Viewport: 1'].view.fitView()
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Model-1'].parts['Draglink']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
o7 = session.odbs['C:/Users/pettlind/Documents/GitHub/MyGitFolder/AlgorithmFinal/Job-1.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    translucency=ON)
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=SHADED, )
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=FILLED, )
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=FILLED, )
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    translucency=OFF)
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=SHADED, )
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=SHADED, )
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=FILLED, )
session.viewports['Viewport: 1'].odbDisplay.commonOptions.setValues(
    renderStyle=SHADED, )
session.viewports['Viewport: 1'].view.setProjection(projection=PERSPECTIVE)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.547811, 
    farPlane=0.949996, width=0.494457, height=0.226546, cameraPosition=(
    0.570064, 0.233659, 0.569671), cameraUpVector=(-0.250575, 0.726871, 
    -0.63943), cameraTarget=(0.000419455, 0.00773681, 0.148433))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.550073, 
    farPlane=0.947734, width=0.496499, height=0.227482, cameraPosition=(
    0.570064, 0.233659, 0.569671), cameraUpVector=(-0.401764, 0.787442, 
    -0.467462), cameraTarget=(0.000419457, 0.00773681, 0.148433))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.549641, 
    farPlane=0.947893, width=0.496109, height=0.227303, cameraPosition=(
    0.409737, 0.380461, 0.64531), cameraUpVector=(-0.523557, 0.648755, 
    -0.552273), cameraTarget=(-0.000710689, 0.00877162, 0.148966))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    DEFORMED, ))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    DEFORMED, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.549666, 
    farPlane=0.947868, width=0.496131, height=0.227313, cameraPosition=(
    0.409737, 0.380461, 0.64531), cameraUpVector=(-0.342049, 0.635355, 
    -0.692335), cameraTarget=(-0.00071069, 0.00877162, 0.148966))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.549666, 
    farPlane=0.947868, width=0.496131, height=0.227313, cameraUpVector=(
    -0.486267, 0.649972, -0.584021), cameraTarget=(-0.000710689, 0.00877162, 
    0.148966))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.558699, 
    farPlane=0.934412, width=0.504285, height=0.231049, cameraPosition=(
    0.375415, 0.487777, 0.575792), cameraUpVector=(-0.508336, 0.504976, 
    -0.697562), cameraTarget=(-0.000946394, 0.00950862, 0.148489))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.558187, 
    farPlane=0.934923, width=0.503823, height=0.230838, cameraPosition=(
    0.375415, 0.487777, 0.575792), cameraUpVector=(-0.689474, 0.495933, 
    -0.527897), cameraTarget=(-0.000946399, 0.00950862, 0.148489))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.557198, 
    farPlane=0.93482, width=0.502931, height=0.230429, cameraPosition=(
    0.439958, 0.464809, 0.537469), cameraUpVector=(-0.698699, 0.53634, 
    -0.473455), cameraTarget=(-0.000692966, 0.00941843, 0.148339))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.557254, 
    farPlane=0.934764, width=0.502981, height=0.230452, cameraPosition=(
    0.439958, 0.464809, 0.537469), cameraUpVector=(-0.619781, 0.541105, 
    -0.568398), cameraTarget=(-0.000692968, 0.00941843, 0.148339))
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.557254, 
    farPlane=0.934764, width=0.502981, height=0.230452, viewOffsetX=0.00310671, 
    viewOffsetY=0.00124232)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.557383, 
    farPlane=0.934635, width=0.472912, height=0.216675, viewOffsetX=0.00954921, 
    viewOffsetY=0.00150356)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.559155, 
    farPlane=0.932863, width=0.474415, height=0.217364, viewOffsetX=0.0128029, 
    viewOffsetY=0.0053166)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.55916, 
    farPlane=0.932857, width=0.47442, height=0.217366, viewOffsetX=0.0262825, 
    viewOffsetY=0.0158627)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.562687, 
    farPlane=0.932406, width=0.477413, height=0.218737, cameraPosition=(
    0.475301, 0.45995, 0.504123), cameraUpVector=(-0.623838, 0.548103, 
    -0.557144), cameraTarget=(0.000403665, 0.0110034, 0.149306), 
    viewOffsetX=0.0264483, viewOffsetY=0.0159628)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.564262, 
    farPlane=0.931035, width=0.478749, height=0.21935, cameraPosition=(
    0.463373, 0.475956, 0.499901), cameraUpVector=(-0.668604, 0.525347, 
    -0.526288), cameraTarget=(0.00222999, 0.00968054, 0.149316), 
    viewOffsetX=0.0265223, viewOffsetY=0.0160075)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.564851, 
    farPlane=0.931484, width=0.47925, height=0.219579, cameraPosition=(
    0.480812, 0.467205, 0.489149), cameraUpVector=(-0.652121, 0.53824, 
    -0.533887), cameraTarget=(0.00193261, 0.0107373, 0.149609), 
    viewOffsetX=0.02655, viewOffsetY=0.0160242)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.56166, 
    farPlane=0.932436, width=0.476543, height=0.218339, cameraPosition=(
    0.459323, 0.467164, 0.514468), cameraUpVector=(-0.638365, 0.538191, 
    -0.55031), cameraTarget=(0.000609332, 0.00997866, 0.149038), 
    viewOffsetX=0.0264, viewOffsetY=0.0159337)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Max. Principal'), )
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.516679, 
    farPlane=0.919058, width=0.438379, height=0.200853, cameraPosition=(
    -0.393304, 0.0387362, 0.735832), cameraUpVector=(-0.115549, 0.846948, 
    -0.518968), cameraTarget=(-0.00270583, -0.0022299, 0.10438), 
    viewOffsetX=0.0242857, viewOffsetY=0.0146576)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.549488, 
    farPlane=0.897094, width=0.466216, height=0.213607, cameraPosition=(
    -0.0525951, 0.200198, 0.833324), cameraUpVector=(0.00722734, 0.821629, 
    -0.569976), cameraTarget=(-0.0285653, 0.00430894, 0.116368), 
    viewOffsetX=0.0258278, viewOffsetY=0.0155883)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.535558, 
    farPlane=0.903751, width=0.454397, height=0.208192, cameraPosition=(
    0.0976172, -0.0373682, 0.846827), cameraUpVector=(-0.0252698, 0.962425, 
    -0.270371), cameraTarget=(-0.0330651, 0.0115584, 0.116413), 
    viewOffsetX=0.025173, viewOffsetY=0.0151931)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.542978, 
    farPlane=0.895446, width=0.460692, height=0.211076, cameraPosition=(
    -0.655554, 0.235867, 0.336092), cameraUpVector=(0.602956, 0.789097, 
    -0.117349), cameraTarget=(0.00952736, 0.00603621, 0.0956323), 
    viewOffsetX=0.0255217, viewOffsetY=0.0154036)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.53167, 
    farPlane=0.912391, width=0.451098, height=0.20668, cameraPosition=(
    -0.18256, 0.203922, 0.808638), cameraUpVector=(-0.00152149, 0.804937, 
    -0.593359), cameraTarget=(-0.0212612, -0.00114709, 0.112287), 
    viewOffsetX=0.0249902, viewOffsetY=0.0150828)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.567082, 
    farPlane=0.900352, width=0.481144, height=0.220447, cameraPosition=(
    0.452902, 0.525087, 0.409402), cameraUpVector=(-0.775805, 0.432104, 
    -0.459798), cameraTarget=(-0.0125634, 0.000329707, 0.162527), 
    viewOffsetX=0.0266547, viewOffsetY=0.0160874)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.54956, 
    farPlane=0.914741, width=0.466278, height=0.213636, cameraPosition=(
    0.297517, 0.502442, 0.595687), cameraUpVector=(-0.714069, 0.430878, 
    -0.551769), cameraTarget=(-0.0164775, -0.0073704, 0.154694), 
    viewOffsetX=0.0258311, viewOffsetY=0.0155903)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.551036, 
    farPlane=0.913266, width=0.485029, height=0.222227, viewOffsetX=0.116519, 
    viewOffsetY=0.0495788)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.505833, 
    farPlane=0.911821, width=0.445242, height=0.203997, cameraPosition=(
    0.389194, 0.279548, 0.666984), cameraUpVector=(-0.545536, 0.725487, 
    -0.419595), cameraTarget=(-0.0417627, -0.0105702, 0.134928), 
    viewOffsetX=0.106961, viewOffsetY=0.0455117)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.50823, 
    farPlane=0.909423, width=0.447352, height=0.204964, viewOffsetX=0.0359026, 
    viewOffsetY=-0.0109002)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.523807, 
    farPlane=0.883436, width=0.461063, height=0.211246, cameraPosition=(
    0.354864, 0.485856, 0.521943), cameraUpVector=(-0.666003, 0.468324, 
    -0.580614), cameraTarget=(-0.0395659, -0.017045, 0.141824), 
    viewOffsetX=0.037003, viewOffsetY=-0.0112343)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.517163, 
    farPlane=0.901345, width=0.455215, height=0.208567, cameraPosition=(
    0.453817, 0.377135, 0.5446), cameraUpVector=(-0.485827, 0.632305, 
    -0.603458), cameraTarget=(-0.0424217, 0.000422205, 0.138632), 
    viewOffsetX=0.0365337, viewOffsetY=-0.0110918)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.557502, 
    farPlane=0.881949, width=0.490723, height=0.224835, cameraPosition=(
    0.655731, 0.26259, 0.303586), cameraUpVector=(-0.537942, 0.730959, 
    -0.419901), cameraTarget=(-0.0309363, 0.014892, 0.161782), 
    viewOffsetX=0.0393834, viewOffsetY=-0.011957)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.55529, 
    farPlane=0.884161, width=0.488776, height=0.223944, viewOffsetX=0.0866254, 
    viewOffsetY=0.0131407)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.493621, 
    farPlane=0.880049, width=0.434495, height=0.199074, cameraPosition=(
    0.445514, 0.360986, 0.530059), cameraUpVector=(-0.53738, 0.643652, 
    -0.544918), cameraTarget=(-0.0636307, -0.0119426, 0.136778), 
    viewOffsetX=0.0770051, viewOffsetY=0.0116813)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.497031, 
    farPlane=0.876639, width=0.437497, height=0.200449, viewOffsetX=0.0553784, 
    viewOffsetY=0.00933066)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.499922, 
    farPlane=0.872619, width=0.440042, height=0.201615, cameraPosition=(
    0.406916, 0.411224, 0.523613), cameraUpVector=(-0.567213, 0.575633, 
    -0.588995), cameraTarget=(-0.061936, -0.0166017, 0.136163), 
    viewOffsetX=0.0557005, viewOffsetY=0.00938493)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.499763, 
    farPlane=0.872778, width=0.439902, height=0.201551, viewOffsetX=0.0472597, 
    viewOffsetY=0.00422094)
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Mises'), )
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.508562, 
    farPlane=0.86398, width=0.32853, height=0.150523, viewOffsetX=0.032124, 
    viewOffsetY=-0.00421015)
session.viewports['Viewport: 1'].view.setValues(nearPlane=0.507254, 
    farPlane=0.865287, width=0.327685, height=0.150136, viewOffsetX=0.038923, 
    viewOffsetY=4.98241e-005)
session.viewports['Viewport: 1'].odbDisplay.displayBodyOptions.setValues(
    visibleEdges=FEATURE)
session.viewports['Viewport: 1'].odbDisplay.displayBodyOptions.setValues(
    visibleEdges=ALL)
session.viewports['Viewport: 1'].odbDisplay.displayBodyOptions.setValues(
    visibleEdges=FREE)
session.Viewport(name='Viewport: 2', origin=(8.46249961853027, 
    228.772491455078), width=505.634338378906, height=253.095001220703)
session.viewports['Viewport: 2'].makeCurrent()
session.viewports['Viewport: 2'].maximize()
session.viewports['Viewport: 1'].restore()
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
session.viewports['Viewport: 2'].restore()
session.viewports['Viewport: 2'].makeCurrent()
session.viewports['Viewport: 2'].maximize()
session.viewports['Viewport: 1'].restore()
session.viewports['Viewport: 2'].odbDisplay.contourOptions.setValues(
    numIntervals=6, maxValue=3.6651E+008, minValue=36205.6)
session.viewports['Viewport: 2'].odbDisplay.contourOptions.setValues(
    numIntervals=7)
session.viewports['Viewport: 2'].odbDisplay.contourOptions.setValues(
    minAutoCompute=OFF, minValue=0)
session.viewports['Viewport: 2'].viewportAnnotationOptions.setValues(
    legendFont='-*-times new roman-medium-r-normal-*-*-300-*-*-p-*-*-*')
session.viewports['Viewport: 2'].viewportAnnotationOptions.setValues(triad=OFF, 
    legendNumberFormat=ENGINEERING, title=OFF, state=OFF, annotations=OFF, 
    compass=OFF)
session.viewports['Viewport: 2'].viewportAnnotationOptions.setValues(
    legendDecimalPlaces=0)
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.510868, 
    farPlane=0.861674, width=0.257662, height=0.118054, viewOffsetX=0.0414229, 
    viewOffsetY=0.00132107)
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.51189, 
    farPlane=0.860652, width=0.258178, height=0.11829, viewOffsetX=0.0469276, 
    viewOffsetY=0.00785994)
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.510792, 
    farPlane=0.861749, width=0.291562, height=0.133586, viewOffsetX=0.0454539, 
    viewOffsetY=0.00719344)
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.509706, 
    farPlane=0.862836, width=0.290942, height=0.133302, viewOffsetX=0.0232536, 
    viewOffsetY=0.00394442)
session.viewports['Viewport: 2'].view.setValues(viewOffsetX=0.0742896, 
    viewOffsetY=0.00466301)
session.tiffOptions.setValues(imageSize=(4080, 3505))
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], session.viewports['Viewport: 1']))
session.viewports['Viewport: 2'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 2'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 2'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 2'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 2'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 2'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
session.viewports['Viewport: 2'].restore()
session.viewports['Viewport: 2'].makeCurrent()
session.viewports['Viewport: 2'].maximize()
session.viewports['Viewport: 1'].restore()
del session.viewports['Viewport: 1']
session.tiffOptions.setValues(imageSize=(4080, 3505))
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.tiffOptions.setValues(imageSize=(4080, 3505))
session.printOptions.setValues(vpDecorations=OFF)
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.graphicsOptions.setValues(backgroundColor='#FFFFFF', 
    backgroundBottomColor='#FFFFFF')
session.tiffOptions.setValues(imageSize=(4080, 3505))
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.printToFile(fileName='result', format=TIFF, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.viewports['Viewport: 2'].viewportAnnotationOptions.setValues(
    legendFont='-*-times new roman-medium-r-normal-*-*-360-*-*-p-*-*-*')
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.506476, 
    farPlane=0.866066, width=0.289102, height=0.132457, viewOffsetX=0.0348249, 
    viewOffsetY=0.00505264)
session.pngOptions.setValues(imageSize=(4080, 1870))
session.printToFile(fileName='result', format=PNG, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.printToFile(fileName='result', format=PNG, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.viewports['Viewport: 2'].viewportAnnotationOptions.setValues(
    legendFont='-*-times new roman-medium-r-normal-*-*-420-*-*-p-*-*-*')
session.printOptions.setValues(rendition=GREYSCALE)
session.printToFile(fileName='result', format=PNG, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.500754, 
    farPlane=0.869022, width=0.285836, height=0.130961, cameraPosition=(
    0.308959, 0.403606, 0.609612), cameraUpVector=(-0.513225, 0.582765, 
    -0.630067), cameraTarget=(-0.0593827, -0.0214065, 0.123132), 
    viewOffsetX=0.0344315, viewOffsetY=0.00499556)
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.506209, 
    farPlane=0.86664, width=0.28895, height=0.132388, cameraPosition=(0.440837, 
    0.385833, 0.511724), cameraUpVector=(-0.548227, 0.609374, -0.572809), 
    cameraTarget=(-0.063932, -0.0125593, 0.138273), viewOffsetX=0.0348066, 
    viewOffsetY=0.00504998)
session.viewports['Viewport: 2'].view.setValues(nearPlane=0.505986, 
    farPlane=0.866862, width=0.288824, height=0.13233, viewOffsetX=0.0155224, 
    viewOffsetY=0.00462899)
session.printOptions.setValues(rendition=COLOR)
session.printToFile(fileName='result', format=PNG, canvasObjects=(
    session.viewports['Viewport: 2'], ))
session.printToFile(fileName='result', format=PNG, canvasObjects=(
    session.viewports['Viewport: 2'], ))
