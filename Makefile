SVG_FIGS = $(wildcard figs/*.svg)
PNG_FIGS = $(SVG_FIGS:.svg=.png)

TARGETS = \
	${PNG_FIGS} \
	figs/Mixed_Air_Damper_Position.pdf \
	figs/Mixed_Air_Damper_Position.png \
	figs/VAV_Occupied_Cooling_Max_Discharge_Air_Flow_Setpoint.pdf \
	figs/VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.pdf \
	figs/VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.png \


all: ${TARGETS}

clean:
	touch ${TARGETS}
	rm ${TARGETS}

mrproper:
	touch dummy~ figs/dummy~ bin/dummy~
	rm    *~     figs/*~     bin/*~


figs/%.png: figs/%.svg
	inkscape -z --export-png=$@ --export-area-page $<

figs/Mixed_Air_Damper_Position.pdf: bin/display-class-tree
	cd figs ; ../bin/display-class-tree ~/vcs/git/GroundTruth/Brick/Brick*.ttl brick:Mixed_Air_Damper_Position
	cd figs ; dot -Tpdf Mixed_Air_Damper_Position.dot -o Mixed_Air_Damper_Position.pdf

figs/Mixed_Air_Damper_Position.png: bin/display-class-tree
	cd figs ; ../bin/display-class-tree ~/vcs/git/GroundTruth/Brick/Brick*.ttl brick:Mixed_Air_Damper_Position
	cd figs ; dot -Tpng Mixed_Air_Damper_Position.dot -o Mixed_Air_Damper_Position.png

figs/VAV_Occupied_Cooling_Max_Discharge_Air_Flow_Setpoint.pdf: bin/display-class-tree
	cd figs ; ../bin/display-class-tree ~/vcs/git/GroundTruth/Brick/Brick*.ttl brick:VAV_Occupied_Cooling_Max_Discharge_Air_Flow_Setpoint
	cd figs ; dot -Tpdf VAV_Occupied_Cooling_Max_Discharge_Air_Flow_Setpoint.dot -o VAV_Occupied_Cooling_Max_Discharge_Air_Flow_Setpoint.pdf

figs/VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.pdf: bin/display-class-tree
	cd figs ; ../bin/display-class-tree ~/vcs/git/GroundTruth/Brick/Brick*.ttl brick:VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint
	cd figs ; dot -Tpdf VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.dot -o VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.pdf

figs/VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.png: bin/display-class-tree
	cd figs ; ../bin/display-class-tree ~/vcs/git/GroundTruth/Brick/Brick*.ttl brick:VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint
	cd figs ; dot -Tpng VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.dot -o VAV_Occupied_Cooling_Discharge_Air_Flow_Setpoint.png

