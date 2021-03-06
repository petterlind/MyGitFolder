# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 6.14-2 replay file
# Internal Version: 2014_08_22-16.00.46 134497
# Run by pettlind on Fri Feb 15 12:28:15 2019
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
import numpy as np
import odbAccess
from abaqusConstants import * 
import time
import os

                     
def create_odb(df):
    # Cross section heights
    h1 = df[0]
    h2 = df[1]
    h3 = df[2]
    h4 = 0.04

    # Cross section widths
    w0 = df[3] # Beginning of shaft
    w1 = df[4] #
    w2 = df[5] #
    w3 = df[6] # Last free cross section.
    w4 = 0.03

    # Cross section distances
    l1 = df[7]
    l2 = df[8]
    l3 = df[9]
    l4 = 0.035



    # # Cross section heights
    # h1 = 0.03
    # h2 = 0.03
    # h3 = 0.035
    # h4 = 0.04
    # 
    # # Cross section widths
    # w0 = 0.03 # Beginning of shaft
    # w1 = 0.03 #
    # w2 = 0.03 #
    # w3 = 0.035 # Last free cross section.
    # w4 = 0.04
    # 
    # # Cross section distances
    # l1 = 0.01
    # l2 = 0.01
    # l3 = 0.01
    # l4 = 0.04

    F = -20000
    M = F*0.1

    session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=358.598419189453, 
        height=217.139999389648)
    session.viewports['Viewport: 1'].makeCurrent()
    session.viewports['Viewport: 1'].maximize()
    from caeModules import *
    from driverUtils import executeOnCaeStartup
    executeOnCaeStartup()
    session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
        referenceRepresentation=ON)
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.2)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=STANDALONE)
    s.Line(point1=(0.005, 0.005), point2=(0.005, -0.00499999994412065))
    s.VerticalConstraint(entity=g[2], addUndoState=False)
    s.undo()
    s.Line(point1=(0.0, 0.005), point2=(0.0, -0.00499999994412065))
    s.VerticalConstraint(entity=g[2], addUndoState=False)
    s.ObliqueDimension(vertex1=v[0], vertex2=v[1], textPoint=(0.00627502053976059, 
        -0.00151421129703522), value=0.05)
    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']
    Mdb()
    #: A new model database has been created.
    #: The model "Model-1" has been created.

    # Base plate
    session.viewports['Viewport: 1'].setValues(displayedObject=None)
    s1 = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.2)
    g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
    s1.sketchOptions.setValues(decimalPlaces=3)
    s1.setPrimaryObject(option=STANDALONE)
    s1.Spot(point=(0.0, 0.0))
    s1.FixedConstraint(entity=v[0])
    s1.rectangle(point1=(0.0, 0.0), point2=(0.03, 0.015)) #base value
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.184378, 
        farPlane=0.192746, width=0.058927, height=0.0294366, cameraPosition=(
        -5.27787e-005, -0.000208699, 0.188562), cameraTarget=(-5.27787e-005, 
        -0.000208699, 0))
    s1.dragEntity(entity=g[2], points=((0.0, 0.00268402346409857), (0.0, 0.0025), (
        0.00125, 0.00301150069572032), (0.00178527762182057, 0.00326620624400675), 
        (0.00218564947135746, 0.00375), (0.0025, 0.00375)))
    s1.dragEntity(entity=g[5], points=((0.00123931956477463, 0.0), (0.00125, 0.0), 
        (0.0025, 0.00125), (0.0025, 0.00125)))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.18203, 
        farPlane=0.195093, width=0.104108, height=0.0520064, cameraPosition=(
        -0.000905401, 0.000107134, 0.188562), cameraTarget=(-0.000905401, 
        0.000107134, 0))
    s1.ObliqueDimension(vertex1=v[4], vertex2=v[5], textPoint=(0.00780775537714362, 
        -0.00288210576400161), value=0.1)
    s1.ObliqueDimension(vertex1=v[1], vertex2=v[2], textPoint=(
        -0.00640337774530053, 0.00676060514524579), value=0.025)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.173903, 
        farPlane=0.203221, width=0.233665, height=0.116726, cameraPosition=(
        -0.00665204, 0.0129701, 0.188562), cameraTarget=(-0.00665204, 0.0129701, 
        0))
    s1.setAsConstruction(objectList=(g[2], g[3], g[4], g[5]))
    s1.rectangle(point1=(0.095, 0.03), point2=(-0.095, -0.03))
    s1.SymmetryConstraint(entity1=g[6], entity2=g[8], symmetryAxis=g[2])
    s1.SymmetryConstraint(entity1=g[7], entity2=g[9], symmetryAxis=g[5])
    s1.CoincidentConstraint(entity1=g[3], entity2=g[9])
    s1.CoincidentConstraint(entity1=g[4], entity2=g[6])
    p = mdb.models['Model-1'].Part(name='Draglink', dimensionality=THREE_D, 
        type=DEFORMABLE_BODY)
    p = mdb.models['Model-1'].parts['Draglink']
    p.BaseSolidExtrude(sketch=s1, depth=0.03)
    s1.unsetPrimaryObject()

    # Distance to planes
    p = mdb.models['Model-1'].parts['Draglink']
    session.viewports['Viewport: 1'].setValues(displayedObject=p)
    del mdb.models['Model-1'].sketches['__profile__']
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XYPLANE, offset=0.03)
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XYPLANE, offset=0.08)
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XYPLANE, offset=0.13)
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XYPLANE, offset=0.18)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.251962, 
        farPlane=0.576858, width=0.492452, height=0.237487, viewOffsetX=0.11676, 
        viewOffsetY=0.0480995)
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XYPLANE, offset=0.023)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=4.29792, 
        farPlane=6.6056, width=14.576, height=7.02935, cameraPosition=(3.18133, 
        3.16696, 3.18444), viewOffsetX=4.06193, viewOffsetY=5.93474)
    session.viewports['Viewport: 1'].view.fitView()
    p = mdb.models['Model-1'].parts['Draglink']
    del p.features['Datum plane-5']
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XYPLANE, offset=0.23)
    p = mdb.models['Model-1'].parts['Draglink']
    f, e, d1 = p.faces, p.edges, p.datums

    # Plane 1
    t = p.MakeSketchTransform(sketchPlane=f[4], sketchUpEdge=e[10], 
        sketchPlaneSide=SIDE1, origin=(0.0, 0.0, 0.03))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.41, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    s.Line(point1=(-0.025, 0.0), point2=(0.0249999999534339, 0.0))
    s.HorizontalConstraint(entity=g[6], addUndoState=False)
    s.PerpendicularConstraint(entity1=g[3], entity2=g[6], addUndoState=False)
    s.CoincidentConstraint(entity1=v[4], entity2=g[3], addUndoState=False)
    s.EqualDistanceConstraint(entity1=v[1], entity2=v[2], midpoint=v[4], 
        addUndoState=False)
    s.CoincidentConstraint(entity1=v[5], entity2=g[5], addUndoState=False)
    s.EqualDistanceConstraint(entity1=v[3], entity2=v[0], midpoint=v[5], 
        addUndoState=False)
    s.setAsConstruction(objectList=(g[6], ))
    s.rectangle(point1=(-0.025, 0.07), point2=(0.025, -0.06))
    s.CoincidentConstraint(entity1=v[6], entity2=g[3], addUndoState=False)
    s.CoincidentConstraint(entity1=v[8], entity2=g[5], addUndoState=False)
    s.SymmetryConstraint(entity1=g[10], entity2=g[8], symmetryAxis=g[6])
    s.DistanceDimension(entity1=g[10], entity2=g[8], textPoint=(0.0577735304832459, 
        -0.0554202683269978), value=w0)

    # Second plane
    p = mdb.models['Model-1'].parts['Draglink']
    f = p.faces
    pickedFaces = f.getSequenceFromMask(mask=('[#10 ]', ), )
    e1, d2 = p.edges, p.datums
    p.PartitionFaceBySketch(sketchUpEdge=e1[10], faces=pickedFaces, sketch=s)
    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']
    p = mdb.models['Model-1'].parts['Draglink']
    e, d1 = p.edges, p.datums
    t = p.MakeSketchTransform(sketchPlane=d1[3], sketchUpEdge=e[6], 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0.0, 0.0, 0.08))
    s1 = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', 
        sheetSize=0.64, gridSpacing=0.01, transform=t)
    g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
    s1.sketchOptions.setValues(decimalPlaces=3)
    s1.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s1, filter=COPLANAR_EDGES)
    s1.ConstructionLine(point1=(0.005, 0.04), point2=(0.005, -0.04))
    s1.VerticalConstraint(entity=g[2], addUndoState=False)
    s1.rectangle(point1=(-0.01, 0.0225), point2=(0.0225, -0.0225))
    s1.SymmetryConstraint(entity1=g[3], entity2=g[5], symmetryAxis=g[2])
    s1.ConstructionLine(point1=(-0.09, 0.0), point2=(0.104999999981374, 0.0))
    s1.HorizontalConstraint(entity=g[7], addUndoState=False)
    s1.SymmetryConstraint(entity1=g[4], entity2=g[6], symmetryAxis=g[7])
    s1.ObliqueDimension(vertex1=v[2], vertex2=v[3], textPoint=(0.048412948846817, 
        0.00956550985574722), value=w1)
    s1.ObliqueDimension(vertex1=v[1], vertex2=v[2], textPoint=(
        -0.00214216113090515, -0.0444011092185974), value=h1)
    s1.ConstructionLine(point1=(0.0, 0.03), point2=(0.0, -0.00642459839582443))
    s1.VerticalConstraint(entity=g[8], addUndoState=False)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.508338, 
        farPlane=0.783638, width=0.319011, height=0.15936, cameraPosition=(
        -0.00201439, 0.000132869, 0.760988), cameraTarget=(-0.00201439, 
        0.000132869, 0.115))
    s1.FixedConstraint(entity=g[8])
    #: Warning: The types of entities do not match.
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.513304, 
        farPlane=0.778672, width=0.249068, height=0.12442, cameraPosition=(
        -0.00920622, 0.018312, 0.760988), cameraTarget=(-0.00920622, 0.018312, 
        0.115))
    s1.DistanceDimension(entity1=g[8], entity2=g[2], textPoint=(
        0.00331255048513412, 0.0285074897110462), value=l1)
        
    # Third plane
    p = mdb.models['Model-1'].parts['Draglink']
    e1, d2 = p.edges, p.datums
    p.Wire(sketchPlane=d2[3], sketchUpEdge=e1[6], sketchPlaneSide=SIDE1, 
        sketchOrientation=RIGHT, sketch=s1)
    s1.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']
    p = mdb.models['Model-1'].parts['Draglink']
    e, d1 = p.edges, p.datums
    t = p.MakeSketchTransform(sketchPlane=d1[4], sketchUpEdge=e[10], 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0.0, 0.00075, 
        0.13))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.64, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    s.ConstructionLine(point1=(0.0, 0.0), point2=(0.0, -0.04))
    s.VerticalConstraint(entity=g[2], addUndoState=False)
    s.FixedConstraint(entity=g[2])
    s.ConstructionLine(point1=(0.01, 0.03), point2=(0.01, -0.0524999999906868))
    s.VerticalConstraint(entity=g[3], addUndoState=False)
    s.DistanceDimension(entity1=g[2], entity2=g[3], textPoint=(0.00614085852354765, 
        0.0309808254241943), value=l2)
    s.rectangle(point1=(-0.0175, 0.025), point2=(0.0325, -0.0275))
    s.SymmetryConstraint(entity1=g[4], entity2=g[6], symmetryAxis=g[3])
    s.ConstructionLine(point1=(-0.0575, 0.0), point2=(0.08, 0.0))
    s.HorizontalConstraint(entity=g[8], addUndoState=False)
    s.SymmetryConstraint(entity1=g[7], entity2=g[5], symmetryAxis=g[8])
    s.ObliqueDimension(vertex1=v[1], vertex2=v[2], textPoint=(0.019279466599226, 
        -0.0492552444338799), value=h2)
    s.ObliqueDimension(vertex1=v[2], vertex2=v[3], textPoint=(0.0526972577273846, 
        -0.0109931975603104), value=w2)

    # Fourth plane
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.507462, 
        farPlane=0.785653, width=0.339373, height=0.169532, cameraPosition=(
        0.00201348, 0.0101364, 0.761558), cameraTarget=(0.00201348, 0.0101364, 
        0.115))
    s.FixedConstraint(entity=g[8])
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.504288, 
        farPlane=0.788828, width=0.434677, height=0.21714, cameraPosition=(
        0.000273971, 0.0394925, 0.761558), cameraTarget=(0.000273971, 0.0394925, 
        0.115))
    p = mdb.models['Model-1'].parts['Draglink']
    e1, d2 = p.edges, p.datums
    p.Wire(sketchPlane=d2[4], sketchUpEdge=e1[10], sketchPlaneSide=SIDE1, 
        sketchOrientation=RIGHT, sketch=s)
    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']
    p = mdb.models['Model-1'].parts['Draglink']
    e, d1 = p.edges, p.datums
    t = p.MakeSketchTransform(sketchPlane=d1[5], sketchUpEdge=e[14], 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0.0, 0.0035, 0.18))
    s1 = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', 
        sheetSize=0.64, gridSpacing=0.01, transform=t)
    g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
    s1.sketchOptions.setValues(decimalPlaces=3)
    s1.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s1, filter=COPLANAR_EDGES)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.511137, 
        farPlane=0.786437, width=0.319011, height=0.15936, cameraPosition=(
        0.00636465, 0.00425653, 0.763787), cameraTarget=(0.00636465, 0.00425653, 
        0.115))
    s1.ConstructionLine(point1=(-0.06, 0.0), point2=(0.05, 0.0))
    s1.HorizontalConstraint(entity=g[2], addUndoState=False)
    s1.ConstructionLine(point1=(0.0, 0.04), point2=(0.0, -0.0449999999627471))
    s1.VerticalConstraint(entity=g[3], addUndoState=False)
    s1.FixedConstraint(entity=g[2])
    s1.FixedConstraint(entity=g[3])
    s1.ConstructionLine(point1=(0.01, 0.0175), point2=(0.01, -0.0149999999487773))
    s1.VerticalConstraint(entity=g[4], addUndoState=False)
    s1.DistanceDimension(entity1=g[3], entity2=g[4], textPoint=(
        0.00479589460045099, 0.0349034667015076), value=l3)
    s1.rectangle(point1=(0.005, 0.02), point2=(0.0425, -0.0225))
    s1.DistanceDimension(entity1=g[5], entity2=g[7], textPoint=(0.0373078283071518, 
        -0.0385715067386627), value=h3)
    s1.ObliqueDimension(vertex1=v[2], vertex2=v[3], textPoint=(0.0595735754966736, 
        -0.00902392528951168), value=w3)
    s1.SymmetryConstraint(entity1=g[8], entity2=g[6], symmetryAxis=g[2])
    s1.SymmetryConstraint(entity1=g[5], entity2=g[7], symmetryAxis=g[4])
    p = mdb.models['Model-1'].parts['Draglink']
    e1, d2 = p.edges, p.datums
    p.Wire(sketchPlane=d2[5], sketchUpEdge=e1[14], sketchPlaneSide=SIDE1, 
        sketchOrientation=RIGHT, sketch=s1)
    s1.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']

    # Fifth Plane
    p = mdb.models['Model-1'].parts['Draglink']
    e, d1 = p.edges, p.datums
    t = p.MakeSketchTransform(sketchPlane=d1[7], sketchUpEdge=e[18], 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0.0, 0.00925, 
        0.23))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.65, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.517858, 
        farPlane=0.79044, width=0.29987, height=0.149798, cameraPosition=(
        0.00198849, 0.0200079, 0.769149), cameraTarget=(0.00198849, 0.0200079, 
        0.115))
    s.ConstructionLine(point1=(-0.01, 0.025), point2=(-0.01, -0.0149999999487773))
    s.VerticalConstraint(entity=g[2], addUndoState=False)
    s.ConstructionLine(point1=(-0.0375, 0.0), point2=(0.00750000003259629, 0.0))
    s.HorizontalConstraint(entity=g[3], addUndoState=False)
    s.FixedConstraint(entity=g[2])
    s.FixedConstraint(entity=g[3])
    s.ConstructionLine(point1=(0.03, 0.0325), point2=(0.03, -0.0149999999487773))
    s.VerticalConstraint(entity=g[4], addUndoState=False)
    s.DistanceDimension(entity1=g[2], entity2=g[4], textPoint=(0.0219637212604284, 
        0.0303227677941322), value=l4)
    s.rectangle(point1=(0.0025, 0.0175), point2=(0.0425, -0.0175))
    s.DistanceDimension(entity1=g[5], entity2=g[7], textPoint=(0.0332621113657951, 
        -0.043372817337513), value=h4)
    s.DistanceDimension(entity1=g[6], entity2=g[8], textPoint=(0.0617859141230583, 
        0.0134727722033858), value=w4)
    s.SymmetryConstraint(entity1=g[5], entity2=g[7], symmetryAxis=g[4])
    s.SymmetryConstraint(entity1=g[6], entity2=g[8], symmetryAxis=g[3])
    p = mdb.models['Model-1'].parts['Draglink']
    e1, d2 = p.edges, p.datums
    p.Wire(sketchPlane=d2[7], sketchUpEdge=e1[18], sketchPlaneSide=SIDE1, 
        sketchOrientation=RIGHT, sketch=s)
    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']

    # Loft
    p = mdb.models['Model-1'].parts['Draglink']
    e, d1 = p.edges, p.datums

    p.SolidLoft(loftsections=((e[16], e[20], e[21], e[22]), (e[4], e[5], e[6], 
        e[7]), (e[8], e[9], e[10], e[11]), (e[0], e[1], e[2], e[3]), (e[12], e[13], 
        e[14], e[15])), startCondition=NONE, endCondition=NONE)
        
    p.Round(radius=0.005, edgeList=(e1[7], e1[11]))
    session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
        engineeringFeatures=ON)
    session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
        referenceRepresentation=OFF)
    mdb.models['Model-1'].Material(name='Material-1')
    mdb.models['Model-1'].materials['Material-1'].Elastic(table=((210000000000.0, 
        0.3), ))
    mdb.models['Model-1'].HomogeneousSolidSection(name='Section-1', 
        material='Material-1', thickness=None)
    p = mdb.models['Model-1'].parts['Draglink']
    c = p.cells
    cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
    region = p.Set(cells=cells, name='Set-1')
    p = mdb.models['Model-1'].parts['Draglink']
    p.SectionAssignment(region=region, sectionName='Section-1', offset=0.0, 
        offsetType=MIDDLE_SURFACE, offsetField='', 
        thicknessAssignment=FROM_SECTION)
    a = mdb.models['Model-1'].rootAssembly
    session.viewports['Viewport: 1'].setValues(displayedObject=a)
    session.viewports['Viewport: 1'].assemblyDisplay.setValues(
        optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
    a = mdb.models['Model-1'].rootAssembly
    a.DatumCsysByDefault(CARTESIAN)

    # Extra holes
    p1 = mdb.models['Model-1'].parts['Draglink']
    session.viewports['Viewport: 1'].setValues(displayedObject=p1)

    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.433097, 
        farPlane=0.776101, width=0.316708, height=0.152734, cameraPosition=(
        0.446113, 0.350628, 0.34497), cameraUpVector=(-0.624592, 0.559655, 
        -0.544675), cameraTarget=(0.00458038, -0.0117569, 0.0981206))
    p = mdb.models['Model-1'].parts['Draglink']
    f, e = p.faces, p.edges
    t = p.MakeSketchTransform(sketchPlane=f.findAt(coordinates=(0.056282, 
        -0.008333, 0.03)), sketchUpEdge=e.findAt(coordinates=(0.1, 0.0125, 0.03)), 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0.067211, 0.0, 
        0.03))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.45, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    s.CircleByCenterPerimeter(center=(0.0, 0.0), point1=(0.0128208643450737, 
        0.0066517312079668))
    s.RadialDimension(curve=g.findAt((-0.012821, -0.006652)), textPoint=(
        0.00386271091842651, 0.000227132812142372), radius=0.012)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.230896, 
        farPlane=0.492254, width=0.220827, height=0.110313, cameraPosition=(
        0.0870367, -0.000688578, 0.476575), cameraTarget=(0.0870367, -0.000688578, 
        0.03))
    session.viewports['Viewport: 1'].view.setValues(cameraPosition=(0.0870367, 
        -0.000688578, 0.476575), cameraUpVector=(0.0724699, 0.997371, 0), 
        cameraTarget=(0.0870367, -0.000688578, 0.03))
    session.viewports['Viewport: 1'].view.setValues(cameraUpVector=(-0.0379224, 
        0.999281, 0))
    s.DistanceDimension(entity1=g.findAt((0.032789, 0.0)), entity2=v.findAt((0.0, 
        0.0)), textPoint=(0.00318630250835418, -0.0172170326113701), value=0.03)
    s.DistanceDimension(entity1=v.findAt((0.002789, 0.0)), entity2=g.findAt((0.0, 
        0.025)), textPoint=(0.0204556754484177, 0.00608985219150782), value=0.025)
    p = mdb.models['Model-1'].parts['Draglink']
    f1, e1 = p.faces, p.edges
    p.CutExtrude(sketchPlane=f1.findAt(coordinates=(0.056282, -0.008333, 0.03)), 
        sketchUpEdge=e1.findAt(coordinates=(0.1, 0.0125, 0.03)), 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, sketch=s, 
        flipExtrudeDirection=OFF)

    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']

    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.457123, 
        farPlane=0.746644, width=0.334278, height=0.161207, cameraPosition=(
        -0.0166455, 0.382117, -0.360737), cameraUpVector=(-0.343547, 0.447489, 
        0.825669), cameraTarget=(0.0182531, -0.0126873, 0.118972))
    p = mdb.models['Model-1'].parts['Draglink']
    f, e = p.faces, p.edges
    t = p.MakeSketchTransform(sketchPlane=f.findAt(coordinates=(0.087536, 0.010519, 
        0.0)), sketchUpEdge=e.findAt(coordinates=(-0.1, -0.0125, 0.0)), 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(-0.003317, 0.0, 
        0.0))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.41, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    s.CircleByCenterPerimeter(center=(0.07, 0.0), point1=(0.0772975593523979, 
        0.0086231492459774))
    s.RadialDimension(curve=g.findAt((0.062702, -0.008623)), textPoint=(
        0.0736656844334602, 0.00512202084064484), radius=0.012)
    s.DistanceDimension(entity1=v.findAt((0.07, 0.0)), entity2=g.findAt((0.096683, 
        0.0)), textPoint=(0.0845613091902733, -0.0171814560890198), value=0.03)
    s.DistanceDimension(entity1=v.findAt((0.066683, 0.0)), entity2=g.findAt((
        -0.003317, 0.025)), textPoint=(0.0859881102757454, 0.0110869035124779), 
        value=0.025)
    p = mdb.models['Model-1'].parts['Draglink']
    f1, e1 = p.faces, p.edges
    p.CutExtrude(sketchPlane=f1.findAt(coordinates=(0.087536, 0.010519, 0.0)), 
        sketchUpEdge=e1.findAt(coordinates=(-0.1, -0.0125, 0.0)), 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, sketch=s, 
        flipExtrudeDirection=OFF)
    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']


    # session.viewports['Viewport: 1'].setValues(displayedObject=None)
    # p = mdb.models['Model-1'].parts['Draglink']
    # f, e = p.faces, p.edges
    # t = p.MakeSketchTransform(sketchPlane=f[13], sketchUpEdge=e[29], 
    #     sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(-0.068917, 0.0, 
    #     0.03))
    # s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', 
    #     sheetSize=0.349, gridSpacing=0.008, transform=t)
    # g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    # s.sketchOptions.setValues(decimalPlaces=3)
    # s.setPrimaryObject(option=SUPERIMPOSE)
    # p = mdb.models['Model-1'].parts['Draglink']
    # p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    # s.CircleByCenterPerimeter(center=(0.008, 0.0), point1=(0.0159369024591446, 
    #     0.0065868366509676))
    # s.RadialDimension(curve=g[13], textPoint=(0.00977006434965133, 
    #     0.00515914894640446), radius=0.012)
    # s.DistanceDimension(entity1=v[10], entity2=g[9], textPoint=(0.0184685501413345, 
    #     -0.0175540782511234), value=0.03)
    # s.DistanceDimension(entity1=v[10], entity2=g[8], textPoint=(0.0183387237744331, 
    #     0.0141795445233583), value=0.025)
    # p = mdb.models['Model-1'].parts['Draglink']
    # f1, e1 = p.faces, p.edges
    # p.CutExtrude(sketchPlane=f1[13], sketchUpEdge=e1[29], sketchPlaneSide=SIDE1, 
    #     sketchOrientation=RIGHT, sketch=s, flipExtrudeDirection=OFF)
    # s.unsetPrimaryObject()
    # del mdb.models['Model-1'].sketches['__profile__']
    # 
    # 
    # # 
    # Ring part
    p = mdb.models['Model-1'].parts['Draglink']
    p.DatumPlaneByPrincipalPlane(principalPlane=XZPLANE, offset=0.054)

    p = mdb.models['Model-1'].parts['Draglink']
    e, d1 = p.edges, p.datums

    t = p.MakeSketchTransform(sketchPlane=d1[18], sketchUpEdge=e.findAt(
        coordinates=(0.0075, 0.05425, 0.23)), sketchPlaneSide=SIDE1, 
        sketchOrientation=RIGHT, origin=(0.0, 0.065, 0.115))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.69, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.620484, 
        farPlane=0.776846, width=0.464314, height=0.231945, cameraPosition=(
        -0.00551905, 0.714614, 0.120227), cameraTarget=(-0.00551905, 0.0159486, 
        0.120227))
    s.Arc3Points(point1=(0.115, -0.015), point2=(0.115, 0.015), point3=(0.155, 
        0.0))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.636582, 
        farPlane=0.760748, width=0.18354, height=0.091686, cameraPosition=(
        -0.00221412, 0.714614, 0.206536), cameraTarget=(-0.00221412, 0.0159486, 
        0.206536))
    s.Line(point1=(0.115, 0.015), point2=(0.115, -0.015))
    s.VerticalConstraint(entity=g.findAt((0.115, 0.0)), addUndoState=False)
    p = mdb.models['Model-1'].parts['Draglink']
    e1, d2 = p.edges, p.datums
    p.SolidExtrude(sketchPlane=d1[18], sketchUpEdge=e1.findAt(coordinates=(0.0075, 
        0.05425, 0.23)), sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, sketch=s, 
        depth=0.04, flipExtrudeDirection=ON)
    s.unsetPrimaryObject()
    del mdb.models['Model-1'].sketches['__profile__']

    # p = mdb.models['Model-1'].parts['Draglink']
    # e = p.edges
    # p.Round(radius=0.0041, edgeList=(e.findAt(coordinates=(-0.0075, 0.02425, 0.23)), 
    #     ))

    p = mdb.models['Model-1'].parts['Draglink']
    f, e1 = p.faces, p.edges
    t = p.MakeSketchTransform(sketchPlane=f.findAt(coordinates=(-0.005, 0.054, 
        0.256403)), sketchUpEdge=e1.findAt(coordinates=(0.0075, 0.05425, 0.23)), 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0.0, 0.054, 
        0.248668))
    s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=0.74, 
        gridSpacing=0.01, transform=t)
    g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
    s.sketchOptions.setValues(decimalPlaces=3)
    s.setPrimaryObject(option=SUPERIMPOSE)
    p = mdb.models['Model-1'].parts['Draglink']
    p.projectReferencesOntoSketch(sketch=s, filter=COPLANAR_EDGES)
    s.CircleByCenterPerimeter(center=(0.0014805, 0.0), point1=(0.0080824344329834, 
        0.00927288830280304))
    s.RadialDimension(curve=g.findAt((-0.005121, -0.009273)), textPoint=(
        0.00119197358417511, 0.0049749780446291), radius=0.01)
    p = mdb.models['Model-1'].parts['Draglink']
    f1, e = p.faces, p.edges
    p.CutExtrude(sketchPlane=f1.findAt(coordinates=(-0.005, 0.054, 0.256403)), 
        sketchUpEdge=e.findAt(coordinates=(0.0075, 0.05425, 0.23)), 
        sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, sketch=s, 
        flipExtrudeDirection=OFF)
    s.unsetPrimaryObject()    
    a = mdb.models['Model-1'].rootAssembly
    a.regenerate()


    # Instance
    p = mdb.models['Model-1'].parts['Draglink']
    a.Instance(name='Draglink-1', part=p, dependent=ON)

    # session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    #     adaptiveMeshConstraints=ON)
    mdb.models['Model-1'].StaticStep(name='Step-1', previous='Initial')
    # session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Step-1')
    # session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON, 
    #     adaptiveMeshConstraints=OFF)
    # session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    #     meshTechnique=ON)

    p = mdb.models['Model-1'].parts['Draglink']
    session.viewports['Viewport: 1'].setValues(displayedObject=p)
    session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
        engineeringFeatures=OFF, mesh=ON)
    session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
        meshTechnique=ON)

    # p = mdb.models['Model-1'].parts['Draglink']
    # p.seedPart(size=0.01, deviationFactor=0.1, minSizeFactor=0.1)
    # # p = mdb.models['Model-1'].parts['Draglink']
    # # p.seedPart(size=0.02, deviationFactor=0.1, minSizeFactor=0.1)
    # # p = mdb.models['Model-1'].parts['Draglink']
    # # p.seedPart(size=0.015, deviationFactor=0.1, minSizeFactor=0.1)

    # p = mdb.models['Model-1'].parts['Draglink']
    # p.seedPart(size=0.012, deviationFactor=0.1, minSizeFactor=0.05)

    p = mdb.models['Model-1'].parts['Draglink']
    p.seedPart(size=0.0075, deviationFactor=0.1, minSizeFactor=0.1)
    p = mdb.models['Model-1'].parts['Draglink']
    c = p.cells
    pickedRegions = c.getSequenceFromMask(mask=('[#1 ]', ), )
    p.setMeshControls(regions=pickedRegions, elemShape=TET, technique=FREE)
    elemType1 = mesh.ElemType(elemCode=C3D20R)
    elemType2 = mesh.ElemType(elemCode=C3D15)
    elemType3 = mesh.ElemType(elemCode=C3D10)
    p = mdb.models['Model-1'].parts['Draglink']
    c = p.cells
    cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
    pickedRegions =(cells, )
    p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
        elemType3))
    p = mdb.models['Model-1'].parts['Draglink']
    p.generateMesh()

    # Reference point
    a = mdb.models['Model-1'].rootAssembly
    a.regenerate()
    a = mdb.models['Model-1'].rootAssembly
    session.viewports['Viewport: 1'].setValues(displayedObject=a)
    session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF, loads=ON, 
        bcs=ON, predefinedFields=ON, connectors=ON)
    session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
        meshTechnique=OFF)
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.517883, 
        farPlane=0.876603, width=0.397463, height=0.191678, cameraPosition=(
        0.422019, 0.41101, -0.269112), cameraUpVector=(-0.957925, 0.214686, 
        -0.1905), cameraTarget=(0.00611613, -0.00291105, 0.121932))


    # Sjukt smutt ! session.journalOptions.setValues(replayGeometry=COORDINATE, recoverGeometry=COORDINATE)
    a = mdb.models['Model-1'].rootAssembly
    f1 = a.instances['Draglink-1'].faces
    faces1 = f1.findAt(((-0.033333, 0.008333, 0.0), ))
    region = a.Set(faces=faces1, name='Set-1')
    mdb.models['Model-1'].EncastreBC(name='BC-1', createStepName='Initial', 
        region=region, localCsys=None)

    # # Reference point
    a = mdb.models['Model-1'].rootAssembly
    a.ReferencePoint(point=(0.0, -0.005, 0.25))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.496035, 
        farPlane=0.877833, width=0.472313, height=0.227775, cameraPosition=(
        0.200834, 0.278195, 0.724845), cameraUpVector=(-0.530122, 0.673086, 
        -0.51568), cameraTarget=(0.00874838, 0.00471675, 0.116952))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=0.504744, 
        farPlane=0.869125, width=0.397061, height=0.191484, 
        viewOffsetX=-0.00917473, viewOffsetY=-0.00410507)
    session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
        predefinedFields=OFF, interactions=ON, constraints=ON, 
        engineeringFeatures=ON)

    # Coupling
    a = mdb.models['Model-1'].rootAssembly
    r1 = a.referencePoints
    refPoints1=(r1[5], )
    region1=a.Set(referencePoints=refPoints1, name='m_Set-2')
    a = mdb.models['Model-1'].rootAssembly
    s1 = a.instances['Draglink-1'].faces
    side1Faces1 = s1.findAt(((-0.000957, 0.027333, 0.257142), ))
    region2=a.Surface(side1Faces=side1Faces1, name='s_Surf-1')
    mdb.models['Model-1'].Coupling(name='Constraint-1', controlPoint=region1, 
        surface=region2, influenceRadius=WHOLE_SURFACE, couplingType=KINEMATIC, 
        localCsys=None, u1=ON, u2=ON, u3=ON, ur1=ON, ur2=ON, ur3=ON)

    a = mdb.models['Model-1'].rootAssembly
    r1 = a.referencePoints
    refPoints1=(r1[5], )
    region = a.Set(referencePoints=refPoints1, name='Set-3')
    mdb.models['Model-1'].ConcentratedForce(name='Load-1', createStepName='Step-1', 
        region=region, cf1=-F, distributionType=UNIFORM, field='', 
        localCsys=None)


    mdb.models['Model-1'].fieldOutputRequests['F-Output-1'].setValues(variables=(
        'S', 'U', 'EVOL'))
    # del mdb.jobs['Job-1']

    mdb.Job(name='Job-1', model='Model-1', description='', type=ANALYSIS, 
        atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
        memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
        explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
        modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='', 
        scratch='', resultsFormat=ODB, multiprocessingMode=DEFAULT, numCpus=8, 
        numDomains=8, numGPUs=0)
    mdb.jobs['Job-1'].submit(consistencyChecking=OFF)

    mdb.jobs['Job-1'].waitForCompletion()
    # vec = [r'\Job-1.lck', r'\Job-1.com', r'\Job-1.dat', r'\Job-1.log', r'\Job-1.msg', r'\Job-1.prt', r'\Job-1.sim', r'\Job-1.sta']
    # 
    # for pos in vec:
    #     try:
    #         os.remove(cwd + pos)
    #     except:
    #         print('Could not remove file:' + pos)
            
    # time.sleep(10)
    # try:
        # open the .odb
def read_odb():
    name = 'result'
    odbObj = odbAccess.openOdb(path='Job-1.odb')
    
    LastFrame = odbObj.steps['Step-1'].frames[-1]
    # choose data
    
    Stress = LastFrame.fieldOutputs['S'].getSubset(position=ELEMENT_NODAL, region=odbObj.rootAssembly.instances['DRAGLINK-1'].elementSets['SET-1'])
    vm_stress = Stress.getScalarField(invariant=MISES)
    #            fieldStressPla = i.fieldOutputs['S'].getSubset(position=ELEMENT_NODAL, region=odbObj.rootAssembly.instances['Draglink-1'].elementSets['MEASURE2'])
    Disp = LastFrame.fieldOutputs['U']
    
    e_vol = LastFrame.fieldOutputs['EVOL']
    # Loop through stress and disp and print down the largest values.
    vm_max = 0
    d_max = 0
    
    # Loop over elements
    e_tot = 0
    for vm, ev in zip(vm_stress.values, e_vol.values):
        vm_max = max(vm_max, vm.data)
        e_tot += ev.data
        # print e_tot
    
    # Loop over nodes    
    for d in Disp.values:
        d_max = max(d_max, np.linalg.norm(d.data))
    
    # writes the input to a file.
    with open('data/' + name + ".csv", "a") as matFile:
            matFile.writelines(str(vm_max) + ',' + str(d_max) + ',' + str(e_tot) + '\n')
    odbObj.close()
            
def removelck():
    cwd = os.getcwd()
    vec = [r'\Job-1.lck', r'\Job-1.com', r'\Job-1.dat', r'\Job-1.log', r'\Job-1.msg', r'\Job-1.prt', r'\Job-1.sim', r'\Job-1.sta']
    
    for pos in vec:
        try:
            os.remove(cwd + pos)
        except:
            print('Could not remove file:' + pos)
            

def removerest():
    cwd = os.getcwd()
    
    vec = [r'\Job-1.lck', r'\Job-1.odb']
    
    for pos in vec:
        try:
            os.remove(cwd + pos)
        except:
            print('Could not remove file:' + pos)
            

df_long = np.genfromtxt('data/MC1.csv', delimiter=",")

for df in df_long:
    try:
        create_odb(df)
        removelck()
        read_odb()
        removerest()
    except:
        try:
            with open('data/NotWorking.csv', "a") as matFile:
                    matFile.writelines(str(df[0]) + ',' + str(df[1]) + ',' + str(df[2])
                    + ',' + str(df[3]) + ',' + str(df[4]) + ',' + str(df[5]) + ','
                    + str(df[6]) + ',' + str(df[7]) + ',' + str(df[8]) + ',' + str(df[9])
                    + '\n') # WRITE THE INPUT
        except:
            # Indented block
            print('nothing')
print('nothing')
