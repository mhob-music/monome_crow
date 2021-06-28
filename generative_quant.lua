--- Subharmonic Quantizer
-- in1: 1/VO input
-- in2: gate
-- out1: quantized 1/VO
-- out2: AR envelope w/ cycling attack and release
-- out3: AR envelope w/ cycling release
-- out4: AR envelope w/ cycling release
gate_counter = 0
xpa = 0
xpb = 0

function init()
	input[1].mode('stream')
	input[2].mode('change', 1, 0.3, 'rising')
	output[1].scale({0.0, 1.67, 5, 7, 8.67})
	output[2].action = ar(0.0, 1, 10, 'logarithmic')
	output[3].action = ar(2, 0.5, 10, 'logarithmic')
	output[4].action = ar(0, 0.5, 10, 'logarithmic')
	i = 0
end

input[2].change = function(state)
	gate_counter = gate_counter + 1
	if gate_counter == 32 then
		xpa = 0
		xpb = 0
		gate_counter = 0
	end
	xpa = xpa + (math.random()-0.5)/32
	xpb = xpb + (math.random()-0.5)/32
	x1 = math.sin(gate_counter/5)
	x2 = math.cos(gate_counter/5)
	output[2].action = ar(math.max(1-x1-xpa, 0.05), math.max(1+x1+xpa, 0.8), 10, 'logarithmic')
	output[3].action = ar(0.01, 1+x2, 10, 'logarithmic')
	output[4].action = ar(0.01, 1+x1, 10, 'logarithmic')
	out_v = input[1].volts + xpb
	output[1].volts = out_v
	output[2](true)
	output[3](true)
	output[4](true)
end
